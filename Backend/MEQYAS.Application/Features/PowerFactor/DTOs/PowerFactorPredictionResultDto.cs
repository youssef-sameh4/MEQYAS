using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.PowerFactor.DTOs
{
    public class PowerFactorPredictionResultDto
    {
        [JsonPropertyName("prediction")]
        public string Prediction { get; set; } = string.Empty;

        [JsonPropertyName("is_low_pf_risk")]
        public bool IsLowPfRisk { get; set; }

        [JsonPropertyName("risk_probability")]
        public decimal RiskProbability { get; set; }

        [JsonPropertyName("risk_percentage")]
        public decimal RiskPercentage { get; set; }

        [JsonPropertyName("threshold_used")]
        public decimal ThresholdUsed { get; set; }

        [JsonPropertyName("actual_power_factor")]
        public decimal ActualPowerFactor { get; set; }

        [JsonPropertyName("computed_q_p_ratio")]
        public decimal ComputedQPRatio { get; set; }

        [JsonPropertyName("message")]
        public string Message { get; set; } = string.Empty;
    }
}
