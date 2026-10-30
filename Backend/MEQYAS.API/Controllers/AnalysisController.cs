using MediatR;
using MEQYAS.Application.Features.Analysis.Commands;
using MEQYAS.Application.Features.Analysis.Commands.Models;
using Microsoft.AspNetCore.Mvc;

namespace MEQYAS.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AnalysisController : ControllerBase
    {
        private readonly IMediator _mediator;

        public AnalysisController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpPost("demo")]
        public async Task<IActionResult> RunDemoAnalysis(
            CancellationToken cancellationToken)
        {
            var result = await _mediator.Send(
                new RunDemoAnalysisCommand(),
                cancellationToken);

            return Ok(result);
        }
    }
}