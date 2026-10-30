using MediatR;
using MEQYAS.Application.Features.EnergyAlerts.Commands.Models;
using MEQYAS.Application.Features.EnergyAlerts.Queries.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MEQYAS.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EnergyAlertsController : ControllerBase
    {
        private readonly IMediator _mediator;

        public EnergyAlertsController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var response = await _mediator.Send(
                new GetAllEnergyAlertsQuery());

            return Ok(response);
        }

        [HttpGet("{id:guid}")]
        public async Task<IActionResult> GetById(Guid id)
        {
            var response = await _mediator.Send(
                new GetEnergyAlertByIdQuery(id));

            return Ok(response);
        }

        [HttpGet("factory/{factoryId:guid}")]
        public async Task<IActionResult> GetByFactoryId(Guid factoryId)
        {
            var response = await _mediator.Send(
                new GetEnergyAlertsByFactoryIdQuery(factoryId));

            return Ok(response);
        }

        // GET: api/EnergyAlerts/ai-anomalies
        [HttpGet("ai-anomalies")]
        public async Task<IActionResult> GetAIAnomalyAlerts()
        {
            var response = await _mediator.Send(
                new GetAIAnomalyAlertsQuery());

            return Ok(response);
        }

        [HttpPost]
        public async Task<IActionResult> Create(
            [FromBody] CreateEnergyAlertCommand command)
        {
            var response = await _mediator.Send(command);
            return Ok(response);
        }

        [HttpPut("{id:guid}")]
        public async Task<IActionResult> Update(
            Guid id,
            [FromBody] UpdateEnergyAlertCommand command)
        {
            if (id != command.Id)
            {
                return BadRequest(
                    "The ID in the URL does not match the ID in the request body.");
            }

            var response = await _mediator.Send(command);
            return Ok(response);
        }

        [HttpDelete("{id:guid}")]
        public async Task<IActionResult> Delete(Guid id)
        {
            var response = await _mediator.Send(
                new DeleteEnergyAlertCommand(id));

            return Ok(response);
        }
    }
}