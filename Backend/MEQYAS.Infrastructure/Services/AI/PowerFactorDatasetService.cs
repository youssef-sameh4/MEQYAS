using System.Globalization;
using MEQYAS.Application.Features.PowerFactor.DTOs;
using MEQYAS.Application.Features.PowerFactor.Interfaces;

namespace MEQYAS.Infrastructure.Services.AI
{
    public class PowerFactorDatasetService : IPowerFactorDatasetService
    {
        private const string DatasetUrl =
            "https://raw.githubusercontent.com/aashour06/meqyas-api/main/data/processed/power_factor.csv";

        private const int MaxRowsToRead = 5000;

        private readonly HttpClient _httpClient;

        public PowerFactorDatasetService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task<List<PowerFactorReadingRequestDto>> LoadReadingsAsync(
            CancellationToken cancellationToken = default)
        {
            using var response = await _httpClient.GetAsync(
                DatasetUrl,
                HttpCompletionOption.ResponseHeadersRead,
                cancellationToken);

            response.EnsureSuccessStatusCode();

            await using var stream = await response.Content.ReadAsStreamAsync(
                cancellationToken);

            using var reader = new StreamReader(stream);

            var headerLine = await reader.ReadLineAsync(cancellationToken);

            if (string.IsNullOrWhiteSpace(headerLine))
            {
                throw new InvalidOperationException(
                    "The Power Factor dataset is empty.");
            }

            var headers = headerLine
                .TrimStart('\uFEFF')
                .Split(',')
                .Select(x => x.Trim())
                .ToArray();

            var indexes = headers
                .Select((header, index) => new { header, index })
                .ToDictionary(
                    x => x.header,
                    x => x.index,
                    StringComparer.OrdinalIgnoreCase);

            var requiredColumns = new[]
            {
                "Timestamp",
                "volt_A",
                "volt_B",
                "volt_C",
                "I_A",
                "I_B",
                "I_C",
                "Total_Active_Power",
                "Total_Reactive_Power",
                "Total_Power_Factor",
                "Freq",
                "Q_P_ratio",
                "hour"
            };

            foreach (var column in requiredColumns)
            {
                if (!indexes.ContainsKey(column))
                {
                    throw new InvalidOperationException(
                        $"Missing dataset column: {column}");
                }
            }

            var readings = new List<PowerFactorReadingRequestDto>();

            string? line;
            var rowsRead = 0;

            while (rowsRead < MaxRowsToRead &&
                   (line = await reader.ReadLineAsync(cancellationToken)) is not null)
            {
                if (string.IsNullOrWhiteSpace(line))
                    continue;

                rowsRead++;

                var values = line.Split(',');

                if (values.Length != headers.Length)
                    continue;

                string GetValue(string column) =>
                    values[indexes[column]].Trim();

                try
                {
                    decimal ParseDecimal(string column) =>
                        decimal.Parse(
                            GetValue(column),
                            CultureInfo.InvariantCulture);

                    readings.Add(new PowerFactorReadingRequestDto
                    {
                        Timestamp = DateTime.Parse(
                            GetValue("Timestamp"),
                            CultureInfo.InvariantCulture),

                        VoltA = ParseDecimal("volt_A"),
                        VoltB = ParseDecimal("volt_B"),
                        VoltC = ParseDecimal("volt_C"),

                        IA = ParseDecimal("I_A"),
                        IB = ParseDecimal("I_B"),
                        IC = ParseDecimal("I_C"),

                        TotalActivePower = ParseDecimal("Total_Active_Power"),
                        TotalReactivePower = ParseDecimal("Total_Reactive_Power"),
                        TotalPowerFactor = ParseDecimal("Total_Power_Factor"),

                        Freq = ParseDecimal("Freq"),
                        QPRatio = ParseDecimal("Q_P_ratio"),
                        Hour = decimal.ToInt32(ParseDecimal("hour"))
                    });
                }
                catch (FormatException)
                {
                    continue;
                }
                catch (OverflowException)
                {
                    continue;
                }
            }

            if (readings.Count == 0)
            {
                throw new InvalidOperationException(
                    "No valid Power Factor readings were found.");
            }

            return readings;
        }

        public async Task<List<PowerFactorReadingRequestDto>> GetRandomReadingsAsync(
            int count,
            CancellationToken cancellationToken = default)
        {
            if (count <= 0)
            {
                throw new ArgumentOutOfRangeException(nameof(count));
            }

            var readings = await LoadReadingsAsync(cancellationToken);

            return readings
                .OrderBy(_ => Random.Shared.Next())
                .Take(count)
                .ToList();
        }
    }
}
