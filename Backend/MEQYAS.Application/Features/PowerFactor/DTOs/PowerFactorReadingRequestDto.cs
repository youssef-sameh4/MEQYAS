using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.PowerFactor.DTOs
{
    public class PowerFactorReadingRequestDto
    {
        [JsonPropertyName("volt_A")]
        public decimal VoltA { get; set; }

        [JsonPropertyName("volt_B")]
        public decimal VoltB { get; set; }

        [JsonPropertyName("volt_C")]
        public decimal VoltC { get; set; }

        [JsonPropertyName("I_A")]
        public decimal IA { get; set; }

        [JsonPropertyName("I_B")]
        public decimal IB { get; set; }

        [JsonPropertyName("I_C")]
        public decimal IC { get; set; }

        [JsonPropertyName("Total_Active_Power")]
        public decimal TotalActivePower { get; set; }

        [JsonPropertyName("Total_Reactive_Power")]
        public decimal TotalReactivePower { get; set; }

        [JsonPropertyName("Total_Power_Factor")]
        public decimal TotalPowerFactor { get; set; }

        [JsonPropertyName("Freq")]
        public decimal Freq { get; set; }

        [JsonPropertyName("Timestamp")]
        public DateTime Timestamp { get; set; }

        [JsonPropertyName("Q_P_ratio")]
        public decimal QPRatio { get; set; }

        [JsonPropertyName("hour")]
        public int Hour { get; set; }
    }
}
