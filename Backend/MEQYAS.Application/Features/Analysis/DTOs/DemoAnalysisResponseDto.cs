using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.Analysis.DTOs
{
    public class DemoAnalysisResponseDto
    {
        [JsonPropertyName("analysisRunId")]
        public Guid AnalysisRunId { get; set; }

        [JsonPropertyName("dataSource")]
        public string DataSource { get; set; } = "DemoDataset";

        [JsonPropertyName("status")]
        public string Status { get; set; } = "Completed";

        [JsonPropertyName("totalReadings")]
        public int TotalReadings { get; set; }

        [JsonPropertyName("anomaliesCount")]
        public int AnomaliesCount { get; set; }

        [JsonPropertyName("normalCount")]
        public int NormalCount { get; set; }

        [JsonPropertyName("anomalyRatePct")]
        public decimal AnomalyRatePct { get; set; }

        [JsonPropertyName("averageAnomalyPercentage")]
        public decimal AverageAnomalyPercentage { get; set; }

        [JsonPropertyName("startedAtUtc")]
        public DateTime StartedAtUtc { get; set; }

        [JsonPropertyName("completedAtUtc")]
        public DateTime? CompletedAtUtc { get; set; }

        [JsonPropertyName("results")]
        public List<DemoAnalysisResultDto> Results { get; set; } = [];
    }

    public class DemoAnalysisResultDto
    {
        [JsonPropertyName("id")]
        public Guid Id { get; set; }

        [JsonPropertyName("energyReadingId")]
        public Guid? EnergyReadingId { get; set; }

        [JsonPropertyName("isAnomaly")]
        public bool IsAnomaly { get; set; }

        [JsonPropertyName("anomalyPercentage")]
        public decimal AnomalyPercentage { get; set; }

        [JsonPropertyName("rawScore")]
        public decimal RawScore { get; set; }

        [JsonPropertyName("prediction")]
        public string Prediction { get; set; } = string.Empty;

        [JsonPropertyName("message")]
        public string? Message { get; set; }
    }
}
