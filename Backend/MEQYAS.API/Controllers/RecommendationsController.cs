using MediatR;
using MEQYAS.Application.Features.Recommendations.Commands.Models;
using MEQYAS.Application.Features.Recommendations.Queries.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MEQYAS.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RecommendationsController : ControllerBase
    {
        private readonly IMediator _mediator;

        public RecommendationsController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpPost]
        public async Task<IActionResult> CreateRecommendation(
            [FromBody] CreateRecommendationCommand command,
            CancellationToken cancellationToken)
        {
            var result = await _mediator.Send(command, cancellationToken);
            return Ok(result);
        }

        [HttpGet]
        public async Task<IActionResult> GetAllRecommendations(
            CancellationToken cancellationToken)
        {
            var result = await _mediator.Send(
                new GetAllRecommendationsQuery(),
                cancellationToken);

            return Ok(result);
        }

        [HttpGet("{id:guid}")]
        public async Task<IActionResult> GetRecommendationById(
            Guid id,
            CancellationToken cancellationToken)
        {
            var result = await _mediator.Send(
                new GetRecommendationByIdQuery { Id = id },
                cancellationToken);

            return Ok(result);
        }

        [HttpGet("factory/{factoryId:guid}")]
        public async Task<IActionResult> GetRecommendationsByFactoryId(
            Guid factoryId,
            CancellationToken cancellationToken)
        {
            var result = await _mediator.Send(
                new GetRecommendationsByFactoryIdQuery
                {
                    FactoryId = factoryId
                },
                cancellationToken);

            return Ok(result);
        }

        [HttpPut]
        public async Task<IActionResult> UpdateRecommendation(
            [FromBody] UpdateRecommendationCommand command,
            CancellationToken cancellationToken)
        {
            var result = await _mediator.Send(command, cancellationToken);
            return Ok(result);
        }

        [HttpDelete("{id:guid}")]
        public async Task<IActionResult> DeleteRecommendation(
            Guid id,
            CancellationToken cancellationToken)
        {
            var result = await _mediator.Send(
                new DeleteRecommendationCommand { Id = id },
                cancellationToken);

            return Ok(result);
        }
    }
}
