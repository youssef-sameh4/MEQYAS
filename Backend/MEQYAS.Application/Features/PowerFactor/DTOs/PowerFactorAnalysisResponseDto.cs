using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.PowerFactor.DTOs
{
    public class PowerFactorAnalysisResponseDto
    {
        public int TotalReadings { get; set; }

        public int LowPfRiskCount { get; set; }

        public int NormalCount { get; set; }

        public decimal RiskRatePct { get; set; }

        public List<PowerFactorPredictionResultDto> Results { get; set; } = new();
    }
}
