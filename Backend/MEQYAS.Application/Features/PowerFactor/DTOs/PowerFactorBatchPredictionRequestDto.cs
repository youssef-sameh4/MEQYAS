using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.PowerFactor.DTOs
{
    public class PowerFactorBatchPredictionRequestDto
    {
        public List<PowerFactorReadingRequestDto> Readings { get; set; } = new();

        public decimal Threshold { get; set; } = 0.5m;
    }
}
