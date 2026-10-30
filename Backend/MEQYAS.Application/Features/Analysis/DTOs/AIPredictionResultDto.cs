using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.Analysis.DTOs
{
    public class AIPredictionResultDto
    {
        [JsonPropertyName("is_anomaly")]
        public bool IsAnomaly { get; set; }

        [JsonPropertyName("prediction")]
        public string Prediction { get; set; } = string.Empty;

        [JsonPropertyName("anomaly_percentage")]
        public decimal AnomalyPercentage { get; set; }

        [JsonPropertyName("raw_score")]
        public decimal RawScore { get; set; }

        [JsonPropertyName("message")]
        public string Message { get; set; } = string.Empty;
    }
}
