using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.Analysis.DTOs
{
    public class AIBatchPredictionRequestDto
    {
        [JsonPropertyName("readings")]
        public List<AIReadingRequestDto> Readings { get; set; } = new();

        [JsonPropertyName("threshold")]
        public decimal Threshold { get; set; } = 50;
    }
}
