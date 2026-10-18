using MediatR;
using MEQYAS.Application.Features.Factories.Commands.Modles;
using MEQYAS.Application.Features.Factories.Queries.Modles;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MEQYAS.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FactoriesController : ControllerBase
    {
        private readonly IMediator _mediator;

        public FactoriesController(IMediator mediator)
        {
            _mediator = mediator;
        }
        [HttpPost]
        public async Task<IActionResult> CreateFactory(CreateFactoryCommand createFactory)
        {
            var response = await _mediator.Send(createFactory);
            return Ok(response);
        }
        [HttpGet]
        public async Task<IActionResult> GetAllFactories()
        {
            var response = await _mediator.Send(
                new GetAllFactoriesQuery());

            return Ok(response);
        }

        [HttpGet("{id:guid}")]
        public async Task<IActionResult> GetFactoryById(Guid id)
        {
            var response = await _mediator.Send(
                new GetFactoryByIdQuery(id));

            return Ok(response);
        }

        [HttpPut("{id:guid}")]
        public async Task<IActionResult> UpdateFactory(
            Guid id,
            [FromBody] UpdateFactoryCommand command)
        {
            command.Id = id;

            var response = await _mediator.Send(command);
            return Ok(response);
        }

        [HttpPatch("{id:guid}/deactivate")]
        public async Task<IActionResult> DeactivateFactory(Guid id)
        {
            var command = new DeactivateFactoryCommand
            {
                Id = id
            };

            var response = await _mediator.Send(command);
            return Ok(response);
        }
    }
}
