using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.Analysis.DTOs
{
    public class AIBatchPredictionResponseDto
    {
        [JsonPropertyName("total_readings")]
        public int TotalReadings { get; set; }

        [JsonPropertyName("anomalies_count")]
        public int AnomaliesCount { get; set; }

        [JsonPropertyName("normal_count")]
        public int NormalCount { get; set; }

        [JsonPropertyName("anomaly_rate_pct")]
        public decimal AnomalyRatePct { get; set; }

        [JsonPropertyName("average_anomaly_percentage")]
        public decimal AverageAnomalyPercentage { get; set; }

        [JsonPropertyName("results")]
        public List<AIPredictionResultDto> Results { get; set; } = new();
    }
}
