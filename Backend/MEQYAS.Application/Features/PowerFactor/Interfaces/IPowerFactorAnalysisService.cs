using MEQYAS.Application.Features.PowerFactor.DTOs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.PowerFactor.Interfaces
{
    public interface IPowerFactorAnalysisService
    {
        Task<PowerFactorBatchPredictionResponseDto> PredictBatchAsync(
            PowerFactorBatchPredictionRequestDto request,
            CancellationToken cancellationToken = default);
    }
}
