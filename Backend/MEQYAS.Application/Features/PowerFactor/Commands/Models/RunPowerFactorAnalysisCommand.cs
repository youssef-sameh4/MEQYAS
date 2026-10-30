using MediatR;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Features.PowerFactor.DTOs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.PowerFactor.Commands.Models
{
    public class RunPowerFactorAnalysisCommand
         : IRequest<Response<PowerFactorAnalysisResponseDto>>
    {
    }
}
