using MEQYAS.Application.Features.Analysis.DTOs;
using MEQYAS.Application.Features.Analysis.Interfaces;
using Microsoft.Extensions.Caching.Memory;
using System.Globalization;

namespace MEQYAS.Infrastructure.Services.AI
{
    public class DemoDatasetService : IDemoDatasetService
    {
        private const string DatasetUrl =
            "https://raw.githubusercontent.com/youssef-sameh4/MEQYAS/main/AI/data/raw/company_A_labelled_subset.csv";

        private const string CacheKey = "MEQYAS_DemoDataset_Readings";

        private readonly HttpClient _httpClient;
        private readonly IMemoryCache _memoryCache;
        private readonly SemaphoreSlim _semaphore = new(1, 1);

        public DemoDatasetService(
            HttpClient httpClient,
            IMemoryCache memoryCache)
        {
            _httpClient = httpClient;
            _memoryCache = memoryCache;
        }

        public async Task<List<AIReadingRequestDto>> LoadReadingsAsync(
            CancellationToken cancellationToken = default)
        {
            if (_memoryCache.TryGetValue(
                CacheKey,
                out List<AIReadingRequestDto>? cachedReadings)
                && cachedReadings is not null)
            {
                return cachedReadings;
            }

            await _semaphore.WaitAsync(cancellationToken);

            try
            {
                if (_memoryCache.TryGetValue(
                    CacheKey,
                    out cachedReadings)
                    && cachedReadings is not null)
                {
                    return cachedReadings;
                }

                var readings = await DownloadAndParseReadingsAsync(
                    cancellationToken);

                _memoryCache.Set(
                    CacheKey,
                    readings,
                    new MemoryCacheEntryOptions
                    {
                        AbsoluteExpirationRelativeToNow =
                            TimeSpan.FromHours(1)
                    });

                return readings;
            }
            finally
            {
                _semaphore.Release();
            }
        }

        private async Task<List<AIReadingRequestDto>>
            DownloadAndParseReadingsAsync(
                CancellationToken cancellationToken)
        {
            using var response = await _httpClient.GetAsync(
                DatasetUrl,
                HttpCompletionOption.ResponseHeadersRead,
                cancellationToken);

            response.EnsureSuccessStatusCode();

            await using var stream =
                await response.Content.ReadAsStreamAsync(
                    cancellationToken);

            using var reader = new StreamReader(stream);

            var readings = new List<AIReadingRequestDto>();

            var headerLine = await reader.ReadLineAsync(
                cancellationToken);

            if (string.IsNullOrWhiteSpace(headerLine))
            {
                throw new InvalidOperationException(
                    "The demo dataset is empty.");
            }

            var headers = headerLine
                .TrimStart('\uFEFF')
                .Split(',')
                .Select(header => header.Trim())
                .ToArray();

            var headerIndexes = headers
                .Select((header, index) => new { header, index })
                .ToDictionary(
                    item => item.header,
                    item => item.index,
                    StringComparer.OrdinalIgnoreCase);

            var requiredColumns = new[]
            {
                "ts",
                "asset",
                "items",
                "status",
                "status_time",
                "power_avg",
                "cycle_time",
                "alarm",
                "product"
            };

            foreach (var column in requiredColumns)
            {
                if (!headerIndexes.ContainsKey(column))
                {
                    throw new InvalidOperationException(
                        $"The dataset is missing the required column: {column}");
                }
            }

            string? line;

            while ((line = await reader.ReadLineAsync(
                cancellationToken)) is not null)
            {
                if (string.IsNullOrWhiteSpace(line))
                {
                    continue;
                }

                var values = line.Split(',');

                if (values.Length != headers.Length)
                {
                    throw new InvalidOperationException(
                        "A CSV row contains an unexpected number of columns.");
                }

                string GetValue(string column) =>
                    values[headerIndexes[column]].Trim();

                int ParseInteger(string column)
                {
                    var rawValue = GetValue(column);

                    var value = decimal.Parse(
                        rawValue,
                        CultureInfo.InvariantCulture);

                    if (value != decimal.Truncate(value))
                    {
                        throw new InvalidOperationException(
                            $"Column '{column}' contains a non-integer value: '{rawValue}'.");
                    }

                    return decimal.ToInt32(value);
                }

                readings.Add(new AIReadingRequestDto
                {
                    Ts = DateTime.Parse(
                        GetValue("ts"),
                        CultureInfo.InvariantCulture),

                    Asset = ParseInteger("asset"),

                    Items = ParseInteger("items"),

                    Status = ParseInteger("status"),

                    StatusTime = decimal.Parse(
                        GetValue("status_time"),
                        CultureInfo.InvariantCulture),

                    PowerAvg = decimal.Parse(
                        GetValue("power_avg"),
                        CultureInfo.InvariantCulture),

                    CycleTime = decimal.Parse(
                        GetValue("cycle_time"),
                        CultureInfo.InvariantCulture),

                    Alarm = ParseInteger("alarm"),

                    Product = ParseInteger("product")
                });
            }

            return readings;
        }
    }
}