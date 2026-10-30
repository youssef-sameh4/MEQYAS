using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.PowerFactor.DTOs
{
    public class PowerFactorBatchPredictionResponseDto
    {
        [JsonPropertyName("total")]
        public int Total { get; set; }

        [JsonPropertyName("low_pf_risk_count")]
        public int LowPfRiskCount { get; set; }

        [JsonPropertyName("normal_count")]
        public int NormalCount { get; set; }

        [JsonPropertyName("risk_rate_pct")]
        public decimal RiskRatePct { get; set; }

        [JsonPropertyName("results")]
        public List<PowerFactorPredictionResultDto> Results { get; set; } = new();
    }
}
