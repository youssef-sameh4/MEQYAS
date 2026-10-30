using MediatR;
using MEQYAS.Application.Features.PowerFactor.Commands.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MEQYAS.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PowerFactorController : ControllerBase
    {
        private readonly IMediator _mediator;

        public PowerFactorController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpPost("run-analysis")]
        public async Task<IActionResult> RunAnalysis(
            CancellationToken cancellationToken)
        {
            var result = await _mediator.Send(
                new RunPowerFactorAnalysisCommand(),
                cancellationToken);

            return Ok(result);
        }
    }
    }
