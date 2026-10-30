using MEQYAS.Application.Features.Analysis.DTOs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.Analysis.Interfaces
{
    public interface IDemoDatasetService
    {
        Task<List<AIReadingRequestDto>> LoadReadingsAsync(
            CancellationToken cancellationToken = default);
    }
}
