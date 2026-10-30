using MEQYAS.Application.Features.PowerFactor.DTOs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.PowerFactor.Interfaces
{
    public interface IPowerFactorDatasetService
    {
        Task<List<PowerFactorReadingRequestDto>> LoadReadingsAsync(
            CancellationToken cancellationToken = default);

        Task<List<PowerFactorReadingRequestDto>> GetRandomReadingsAsync(
            int count,
            CancellationToken cancellationToken = default);
    }
}
