using MediatR;
using MEQYAS.Application.Features.SavingsSimulations.Commands.Models;
using MEQYAS.Application.Features.SavingsSimulations.Queries.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MEQYAS.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SavingsSimulationsController : ControllerBase
    {
        private readonly IMediator _mediator;

        public SavingsSimulationsController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpPost]
        public async Task<IActionResult> Create(
            [FromBody] CreateSavingsSimulationCommand command)
        {
            var response = await _mediator.Send(command);
            return StatusCode((int)response.StatusCode, response);
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var response = await _mediator.Send(
                new GetAllSavingsSimulationsQuery());

            return StatusCode((int)response.StatusCode, response);
        }

        [HttpGet("{id:guid}")]
        public async Task<IActionResult> GetById(Guid id)
        {
            var response = await _mediator.Send(
                new GetSavingsSimulationByIdQuery { Id = id });

            return StatusCode((int)response.StatusCode, response);
        }

        [HttpGet("factory/{factoryId:guid}")]
        public async Task<IActionResult> GetByFactoryId(Guid factoryId)
        {
            var response = await _mediator.Send(
                new GetSavingsSimulationsByFactoryIdQuery
                {
                    FactoryId = factoryId
                });

            return StatusCode((int)response.StatusCode, response);
        }

        [HttpPut("{id:guid}")]
        public async Task<IActionResult> Update(
            Guid id,
            [FromBody] UpdateSavingsSimulationCommand command)
        {
            if (id != command.Id)
                return BadRequest("Route ID does not match the request ID.");

            var response = await _mediator.Send(command);

            return StatusCode((int)response.StatusCode, response);
        }

        [HttpDelete("{id:guid}")]
        public async Task<IActionResult> Delete(Guid id)
        {
            var response = await _mediator.Send(
                new DeleteSavingsSimulationCommand { Id = id });

            return StatusCode((int)response.StatusCode, response);
        }
    }
}
