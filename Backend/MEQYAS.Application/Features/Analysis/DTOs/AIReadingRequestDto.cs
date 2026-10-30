using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.Analysis.DTOs
{

    public class AIReadingRequestDto
    {
        [JsonPropertyName("asset")]
        public int Asset { get; set; }

        [JsonPropertyName("items")]
        public int Items { get; set; }

        [JsonPropertyName("status")]
        public int Status { get; set; }

        [JsonPropertyName("power_avg")]
        public decimal PowerAvg { get; set; }

        [JsonPropertyName("alarm")]
        public int Alarm { get; set; }

        [JsonPropertyName("product")]
        public int Product { get; set; }

        [JsonPropertyName("ts")]
        public DateTime Ts { get; set; }

        [JsonPropertyName("status_time")]
        public decimal StatusTime { get; set; }

        [JsonPropertyName("cycle_time")]
        public decimal CycleTime { get; set; }

        [JsonPropertyName("threshold")]
        public decimal Threshold { get; set; } = 50;
    }
}
