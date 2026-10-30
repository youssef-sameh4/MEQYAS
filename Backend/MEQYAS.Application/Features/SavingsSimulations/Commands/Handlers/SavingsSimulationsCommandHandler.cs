using AutoMapper;
using MediatR;
using MEQYAS.Application.Abstractions.Interfaces;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Bases.MEQYAS.Application.Bases;
using MEQYAS.Application.Features.SavingsSimulations.Commands.Models;
using MEQYAS.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.SavingsSimulations.Commands.Handlers
{
    public class SavingsSimulationsCommandHandler :
    ResponseHandler,
    IRequestHandler<CreateSavingsSimulationCommand, Response<string>>,
    IRequestHandler<UpdateSavingsSimulationCommand, Response<string>>,
    IRequestHandler<DeleteSavingsSimulationCommand, Response<string>>
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IMapper _mapper;

        public SavingsSimulationsCommandHandler(
            IUnitOfWork unitOfWork,
            IMapper mapper)
        {
            _unitOfWork = unitOfWork;
            _mapper = mapper;
        }

        public async Task<Response<string>> Handle(
            CreateSavingsSimulationCommand request,
            CancellationToken cancellationToken)
        {
            var factory = await _unitOfWork.Factories
                .GetTableNoTracking()
                .FirstOrDefaultAsync(
                    f => f.Id == request.FactoryId,
                    cancellationToken);

            if (factory is null)
                return NotFound<string>("Factory not found.");

            if (request.RecommendationId.HasValue)
            {
                var recommendation = await _unitOfWork.Recommendations
                    .GetTableNoTracking()
                    .FirstOrDefaultAsync(
                        r => r.Id == request.RecommendationId.Value,
                        cancellationToken);

                if (recommendation is null)
                    return NotFound<string>("Recommendation not found.");

                if (recommendation.FactoryId != request.FactoryId)
                {
                    return BadRequest<string>(
                        "The recommendation does not belong to the specified factory.");
                }
            }

            var simulation = _mapper.Map<SavingsSimulation>(request);

            var reductionFactor =
                1 - request.ReductionPercentage / 100m;

            simulation.Id = Guid.NewGuid();

            simulation.ProjectedConsumptionKwh = Math.Round(
                request.BaselineConsumptionKwh * reductionFactor, 2);

            simulation.ProjectedCost = Math.Round(
                request.BaselineCost * reductionFactor, 2);

            simulation.EstimatedSavingsAmount = Math.Round(
                request.BaselineCost - simulation.ProjectedCost, 2);

            simulation.CurrencyCode =
                request.CurrencyCode.Trim().ToUpperInvariant();

            simulation.CreatedAtUtc = DateTime.UtcNow;

            await _unitOfWork.SavingsSimulations
                .AddAsync(simulation, cancellationToken);

            await _unitOfWork.SaveChangesAsync();

            return Created<string>(simulation.Id.ToString());
        }

        public async Task<Response<string>> Handle(
            UpdateSavingsSimulationCommand request,
            CancellationToken cancellationToken)
        {
            var simulation = await _unitOfWork.SavingsSimulations
                .GetTableAsTracking()
                .FirstOrDefaultAsync(
                    s => s.Id == request.Id,
                    cancellationToken);

            if (simulation is null)
                return NotFound<string>("Savings simulation not found.");

            var factory = await _unitOfWork.Factories
                .GetTableNoTracking()
                .FirstOrDefaultAsync(
                    f => f.Id == request.FactoryId,
                    cancellationToken);

            if (factory is null)
                return NotFound<string>("Factory not found.");

            if (request.RecommendationId.HasValue)
            {
                var recommendation = await _unitOfWork.Recommendations
                    .GetTableNoTracking()
                    .FirstOrDefaultAsync(
                        r => r.Id == request.RecommendationId.Value,
                        cancellationToken);

                if (recommendation is null)
                    return NotFound<string>("Recommendation not found.");

                if (recommendation.FactoryId != request.FactoryId)
                {
                    return BadRequest<string>(
                        "The recommendation does not belong to the specified factory.");
                }
            }

            _mapper.Map(request, simulation);

            var reductionFactor =
                1 - request.ReductionPercentage / 100m;

            simulation.ProjectedConsumptionKwh = Math.Round(
                request.BaselineConsumptionKwh * reductionFactor, 2);

            simulation.ProjectedCost = Math.Round(
                request.BaselineCost * reductionFactor, 2);

            simulation.EstimatedSavingsAmount = Math.Round(
                request.BaselineCost - simulation.ProjectedCost, 2);

            simulation.CurrencyCode =
                request.CurrencyCode.Trim().ToUpperInvariant();

            await _unitOfWork.SaveChangesAsync();

            return Success<string>(
                "Savings simulation updated successfully.");
        }

        public async Task<Response<string>> Handle(
            DeleteSavingsSimulationCommand request,
            CancellationToken cancellationToken)
        {
            var simulation = await _unitOfWork.SavingsSimulations
                .GetTableAsTracking()
                .FirstOrDefaultAsync(
                    s => s.Id == request.Id,
                    cancellationToken);

            if (simulation is null)
                return NotFound<string>("Savings simulation not found.");

            _unitOfWork.SavingsSimulations.Delete(simulation);

            await _unitOfWork.SaveChangesAsync();

            return Deleted<string>();
        }
    }
}
