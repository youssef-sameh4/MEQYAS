using MediatR;
using MEQYAS.Application.Features.EnergyTariffs.Commands.Models;
using MEQYAS.Application.Features.EnergyTariffs.Queries.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MEQYAS.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EnergyTariffsController : ControllerBase
    {
        private readonly IMediator _mediator;

        public EnergyTariffsController(IMediator mediator)
        {
            _mediator = mediator;
        }

        // Create Energy Tariff
        [HttpPost("Create")]
        public async Task<IActionResult> CreateEnergyTariff(
            [FromBody] CreateEnergyTariffCommand command)
        {
            var response = await _mediator.Send(command);
            return Ok(response);
        }

        // Update Energy Tariff
        [HttpPut("Update/{id:guid}")]
        public async Task<IActionResult> UpdateEnergyTariff(
            [FromRoute] Guid id,
            [FromBody] UpdateEnergyTariffCommand command)
        {
            if (id != command.Id)
            {
                return BadRequest(
                    "The ID in the URL does not match the ID in the request body.");
            }

            var response = await _mediator.Send(command);
            return Ok(response);
        }

        // Get All Energy Tariffs
        [HttpGet("GetAll")]
        public async Task<IActionResult> GetAllEnergyTariffs()
        {
            var response = await _mediator.Send(
                new GetAllEnergyTariffsQuery());

            return Ok(response);
        }

        // Get Energy Tariff By ID
        [HttpGet("GetById/{id:guid}")]
        public async Task<IActionResult> GetEnergyTariffById(
            [FromRoute] Guid id)
        {
            var response = await _mediator.Send(
                new GetEnergyTariffByIdQuery(id) );

            return Ok(response);
        }

        // Get Energy Tariffs By Factory ID
        [HttpGet("GetByFactoryId/{factoryId:guid}")]
        public async Task<IActionResult> GetEnergyTariffsByFactoryId(
            [FromRoute] Guid factoryId)
        {
            var response = await _mediator.Send(
                new GetEnergyTariffsByFactoryIdQuery
                    (factoryId)
               );

            return Ok(response);
        }

}
}
