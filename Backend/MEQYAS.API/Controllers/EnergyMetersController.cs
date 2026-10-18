using MediatR;
using MEQYAS.Application.Features.EnergyMeters.Commands.Models;
using MEQYAS.Application.Features.EnergyMeters.Queries.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MEQYAS.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EnergyMetersController : ControllerBase
    {
        private readonly IMediator _mediator;

        public EnergyMetersController(IMediator mediator)
        {
            _mediator = mediator;
        }

        // POST: api/EnergyMeters
        [HttpPost]
        public async Task<IActionResult> CreateEnergyMeter(
            [FromBody] CreateEnergyMeterCommand command)
        {
            var response = await _mediator.Send(command);
            return Ok(response);
        }

        // GET: api/EnergyMeters
        [HttpGet]
        public async Task<IActionResult> GetAllEnergyMeters()
        {
            var response = await _mediator.Send(
                new GetAllEnergyMetersQuery());

            return Ok(response);
        }

        // GET: api/EnergyMeters/{id}
        [HttpGet("{id:guid}")]
        public async Task<IActionResult> GetEnergyMeterById(Guid id)
        {
            var response = await _mediator.Send(
                new GetEnergyMeterByIdQuery
                {
                    Id = id
                });

            return Ok(response);
        }

        // GET: api/EnergyMeters/factory/{factoryId}
        [HttpGet("factory/{factoryId:guid}")]
        public async Task<IActionResult> GetEnergyMetersByFactoryId(
            Guid factoryId)
        {
            var response = await _mediator.Send(
                new GetEnergyMetersByFactoryIdQuery
                {
                    FactoryId = factoryId
                });

            return Ok(response);
        }

        // PUT: api/EnergyMeters/{id}
        [HttpPut("{id:guid}")]
        public async Task<IActionResult> UpdateEnergyMeter(
            Guid id,
            [FromBody] UpdateEnergyMeterCommand command)
        {
            command.Id = id;

            var response = await _mediator.Send(command);
            return Ok(response);
        }

        // PATCH: api/EnergyMeters/{id}/deactivate
        [HttpPatch("{id:guid}/deactivate")]
        public async Task<IActionResult> DeactivateEnergyMeter(Guid id)
        {
            var response = await _mediator.Send(
                new DeactivateEnergyMeterCommand
                {
                    Id = id
                });

            return Ok(response);
        }
    }
}
