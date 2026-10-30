using MediatR;
using MEQYAS.Application.Features.EnergyReadings.Commands.Models;
using MEQYAS.Application.Features.EnergyReadings.Queries.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MEQYAS.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EnergyReadingsController : ControllerBase
    {
        private readonly IMediator _mediator;

        public EnergyReadingsController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpPost("Create")]
        public async Task<IActionResult> CreateEnergyReading(
            [FromBody] CreateEnergyReadingCommand command)
        {
            var response = await _mediator.Send(command);
            return Ok(response);
        }

        [HttpGet("GetAll")]
        public async Task<IActionResult> GetAllEnergyReadings()
        {
            var response = await _mediator.Send(new GetAllEnergyReadingsQuery());
            return Ok(response);
        }

        [HttpGet("GetById/{id:guid}")]
        public async Task<IActionResult> GetEnergyReadingById(Guid id)
        {
            var response = await _mediator.Send(new GetEnergyReadingByIdQuery(id));
            return Ok(response);
        }

        [HttpGet("GetByMeterId/{energyMeterId:guid}")]
        public async Task<IActionResult> GetEnergyReadingsByMeterId(Guid energyMeterId)
        {
            var response = await _mediator.Send(
                new GetEnergyReadingsByMeterIdQuery(energyMeterId));

            return Ok(response);
        }

        [HttpGet("GetByDateRange/{energyMeterId:guid}")]
        public async Task<IActionResult> GetEnergyReadingsByDateRange(
            Guid energyMeterId,
            [FromQuery] DateTime fromUtc,
            [FromQuery] DateTime toUtc)
        {
            var response = await _mediator.Send(
                new GetEnergyReadingsByDateRangeQuery(
                    energyMeterId,
                    fromUtc,
                    toUtc));

            return Ok(response);
        }

    }
}
