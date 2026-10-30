using MediatR;
using MEQYAS.Application.Abstractions.Interfaces;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Bases.MEQYAS.Application.Bases;
using MEQYAS.Application.Features.SavingsSimulations.Queries.DTOS;
using MEQYAS.Application.Features.SavingsSimulations.Queries.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.SavingsSimulations.Queries.Handlers
{
    public class SavingsSimulationsQueryHandler : ResponseHandler,
    IRequestHandler<GetAllSavingsSimulationsQuery,
        Response<List<SavingsSimulationDto>>>,
    IRequestHandler<GetSavingsSimulationByIdQuery,
        Response<SavingsSimulationDto>>,
    IRequestHandler<GetSavingsSimulationsByFactoryIdQuery,
        Response<List<SavingsSimulationDto>>>
    {
        private readonly IUnitOfWork _unitOfWork;

        public SavingsSimulationsQueryHandler(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Response<List<SavingsSimulationDto>>> Handle(
            GetAllSavingsSimulationsQuery request,
            CancellationToken cancellationToken)
        {
            var simulations = await _unitOfWork.SavingsSimulations
                .GetTableNoTracking()
                .OrderByDescending(s => s.CreatedAtUtc)
                .Select(s => new SavingsSimulationDto
                {
                    Id = s.Id,
                    FactoryId = s.FactoryId,
                    RecommendationId = s.RecommendationId,
                    Name = s.Name,
                    BaselineConsumptionKwh = s.BaselineConsumptionKwh,
                    ReductionPercentage = s.ReductionPercentage,
                    BaselineCost = s.BaselineCost,
                    ProjectedConsumptionKwh = s.ProjectedConsumptionKwh,
                    ProjectedCost = s.ProjectedCost,
                    EstimatedSavingsAmount = s.EstimatedSavingsAmount,
                    CurrencyCode = s.CurrencyCode,
                    CreatedAtUtc = s.CreatedAtUtc
                })
                .ToListAsync(cancellationToken);

            return Success<List<SavingsSimulationDto>>(simulations);
        }

        public async Task<Response<SavingsSimulationDto>> Handle(
            GetSavingsSimulationByIdQuery request,
            CancellationToken cancellationToken)
        {
            var simulation = await _unitOfWork.SavingsSimulations
                .GetTableNoTracking()
                .Where(s => s.Id == request.Id)
                .Select(s => new SavingsSimulationDto
                {
                    Id = s.Id,
                    FactoryId = s.FactoryId,
                    RecommendationId = s.RecommendationId,
                    Name = s.Name,
                    BaselineConsumptionKwh = s.BaselineConsumptionKwh,
                    ReductionPercentage = s.ReductionPercentage,
                    BaselineCost = s.BaselineCost,
                    ProjectedConsumptionKwh = s.ProjectedConsumptionKwh,
                    ProjectedCost = s.ProjectedCost,
                    EstimatedSavingsAmount = s.EstimatedSavingsAmount,
                    CurrencyCode = s.CurrencyCode,
                    CreatedAtUtc = s.CreatedAtUtc
                })
                .FirstOrDefaultAsync(cancellationToken);

            if (simulation is null)
                return NotFound<SavingsSimulationDto>(
                    "Savings simulation not found.");

            return Success<SavingsSimulationDto>(simulation);
        }

        public async Task<Response<List<SavingsSimulationDto>>> Handle(
            GetSavingsSimulationsByFactoryIdQuery request,
            CancellationToken cancellationToken)
        {
            var factoryExists = await _unitOfWork.Factories
                .GetTableNoTracking()
                .AnyAsync(
                    f => f.Id == request.FactoryId,
                    cancellationToken);

            if (!factoryExists)
                return NotFound<List<SavingsSimulationDto>>(
                    "Factory not found.");

            var simulations = await _unitOfWork.SavingsSimulations
                .GetTableNoTracking()
                .Where(s => s.FactoryId == request.FactoryId)
                .OrderByDescending(s => s.CreatedAtUtc)
                .Select(s => new SavingsSimulationDto
                {
                    Id = s.Id,
                    FactoryId = s.FactoryId,
                    RecommendationId = s.RecommendationId,
                    Name = s.Name,
                    BaselineConsumptionKwh = s.BaselineConsumptionKwh,
                    ReductionPercentage = s.ReductionPercentage,
                    BaselineCost = s.BaselineCost,
                    ProjectedConsumptionKwh = s.ProjectedConsumptionKwh,
                    ProjectedCost = s.ProjectedCost,
                    EstimatedSavingsAmount = s.EstimatedSavingsAmount,
                    CurrencyCode = s.CurrencyCode,
                    CreatedAtUtc = s.CreatedAtUtc
                })
                .ToListAsync(cancellationToken);

            return Success<List<SavingsSimulationDto>>(simulations);
        }
    }
}