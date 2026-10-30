using MediatR;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Features.Analysis.DTOs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.Analysis.Commands.Models
{
    public class RunDemoAnalysisCommand
          : IRequest<Response<DemoAnalysisResponseDto>>
    {
    }
}
