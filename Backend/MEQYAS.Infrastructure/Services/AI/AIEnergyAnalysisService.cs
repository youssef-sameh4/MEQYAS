using MEQYAS.Application.Features.Analysis.DTOs;
using MEQYAS.Application.Features.Analysis.Interfaces;
using System.Net.Http.Json;

namespace MEQYAS.Infrastructure.Services.AI
{
    public class AIEnergyAnalysisService : IAIEnergyAnalysisService
    {
        private readonly HttpClient _httpClient;

        private const int BatchSize = 100;

        public AIEnergyAnalysisService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task<AIBatchPredictionResponseDto> PredictBatchAsync(
            AIBatchPredictionRequestDto request,
            CancellationToken cancellationToken = default)
        {
            if (request.Readings.Count == 0)
            {
                return new AIBatchPredictionResponseDto();
            }

            var combinedResults = new List<AIPredictionResultDto>();

            var totalAnomalies = 0;
            var totalNormal = 0;
            var totalReadings = 0;

            foreach (var batch in request.Readings.Chunk(BatchSize))
            {
                cancellationToken.ThrowIfCancellationRequested();

                var batchRequest = new AIBatchPredictionRequestDto
                {
                    Readings = batch.ToList(),
                    Threshold = request.Threshold
                };

                var response = await _httpClient.PostAsJsonAsync(
                    "predict/batch",
                    batchRequest,
                    cancellationToken);

                response.EnsureSuccessStatusCode();

                var batchResponse = await response.Content
                    .ReadFromJsonAsync<AIBatchPredictionResponseDto>(
                        cancellationToken: cancellationToken);

                if (batchResponse == null)
                {
                    throw new InvalidOperationException(
                        "The AI API returned an empty response.");
                }

                if (batchResponse.Results.Count != batch.Length)
                {
                    throw new InvalidOperationException(
                        $"The AI API returned {batchResponse.Results.Count} results " +
                        $"for a batch containing {batch.Length} readings.");
                }

                combinedResults.AddRange(batchResponse.Results);

                totalReadings += batchResponse.TotalReadings;
                totalAnomalies += batchResponse.AnomaliesCount;
                totalNormal += batchResponse.NormalCount;
            }

            var anomalyRate = totalReadings == 0
                ? 0
                : Math.Round(
                    (decimal)totalAnomalies / totalReadings * 100,
                    2);

            var averageAnomalyPercentage = combinedResults.Count == 0
                ? 0
                : Math.Round(
                    combinedResults.Average(x => x.AnomalyPercentage),
                    2);

            return new AIBatchPredictionResponseDto
            {
                TotalReadings = totalReadings,
                AnomaliesCount = totalAnomalies,
                NormalCount = totalNormal,
                AnomalyRatePct = anomalyRate,
                AverageAnomalyPercentage = averageAnomalyPercentage,
                Results = combinedResults
            };
        }
    }
}