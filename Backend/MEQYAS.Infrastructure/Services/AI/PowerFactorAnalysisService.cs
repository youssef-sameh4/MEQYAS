using MEQYAS.Application.Features.PowerFactor.DTOs;
using MEQYAS.Application.Features.PowerFactor.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Json;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace MEQYAS.Infrastructure.Services.AI
{
    public class PowerFactorAnalysisService : IPowerFactorAnalysisService
    {
        private readonly HttpClient _httpClient;

        private const int BatchSize = 100;

        public PowerFactorAnalysisService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task<PowerFactorBatchPredictionResponseDto> PredictBatchAsync(
            PowerFactorBatchPredictionRequestDto request,
            CancellationToken cancellationToken = default)
        {
            if (request.Readings.Count == 0)
            {
                return new PowerFactorBatchPredictionResponseDto();
            }

            var combinedResults = new List<PowerFactorPredictionResultDto>();

            var total = 0;
            var lowPfRiskCount = 0;
            var normalCount = 0;

            foreach (var batch in request.Readings.Chunk(BatchSize))
            {
                cancellationToken.ThrowIfCancellationRequested();

                var batchRequest = new PowerFactorBatchPredictionRequestDto
                {
                    Readings = batch.ToList(),
                    Threshold = request.Threshold
                };

                var response = await _httpClient.PostAsJsonAsync(
                    "power/predict/batch",
                    batchRequest,
                    cancellationToken);

                var responseContent = await response.Content.ReadAsStringAsync(
                    cancellationToken);

                if (!response.IsSuccessStatusCode)
                {
                    throw new HttpRequestException(
                        $"Power Factor AI API Error: " +
                        $"{(int)response.StatusCode} - {response.ReasonPhrase}. " +
                        $"Details: {responseContent}");
                }

                var batchResponse =
                    JsonSerializer.Deserialize<PowerFactorBatchPredictionResponseDto>(
                        responseContent);

                if (batchResponse is null)
                {
                    throw new InvalidOperationException(
                        "The Power Factor AI API returned an empty response.");
                }

                if (batchResponse.Results.Count != batch.Length)
                {
                    throw new InvalidOperationException(
                        $"Expected {batch.Length} results, " +
                        $"but received {batchResponse.Results.Count}.");
                }

                combinedResults.AddRange(batchResponse.Results);

                total += batchResponse.Total;
                lowPfRiskCount += batchResponse.LowPfRiskCount;
                normalCount += batchResponse.NormalCount;
            }

            return new PowerFactorBatchPredictionResponseDto
            {
                Total = total,
                LowPfRiskCount = lowPfRiskCount,
                NormalCount = normalCount,

                RiskRatePct = total == 0
                    ? 0
                    : Math.Round(
                        (decimal)lowPfRiskCount / total * 100,
                        2),

                Results = combinedResults
            };
        }
    
}
}