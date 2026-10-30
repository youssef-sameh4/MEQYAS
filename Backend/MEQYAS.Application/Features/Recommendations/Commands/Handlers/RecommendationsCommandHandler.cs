using AutoMapper;
using MediatR;
using MEQYAS.Application.Abstractions.Interfaces;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Bases.MEQYAS.Application.Bases;
using MEQYAS.Application.Features.Recommendations.Commands.Models;
using MEQYAS.Domain.Entities;
using MEQYAS.Domain.Enums;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.Recommendations.Commands.Handlers
{
    public class RecommendationsCommandHandler :
     ResponseHandler,
     IRequestHandler<CreateRecommendationCommand, Response<string>>,
     IRequestHandler<UpdateRecommendationCommand, Response<string>>,
     IRequestHandler<DeleteRecommendationCommand, Response<string>>
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IMapper _mapper;

        public RecommendationsCommandHandler(
            IUnitOfWork unitOfWork,
            IMapper mapper)
        {
            _unitOfWork = unitOfWork;
            _mapper = mapper;
        }

        public async Task<Response<string>> Handle(
            CreateRecommendationCommand request,
            CancellationToken cancellationToken)
        {
            var factory = await _unitOfWork.Factories
                .GetTableNoTracking()
                .FirstOrDefaultAsync(
                    f => f.Id == request.FactoryId,
                    cancellationToken);

            if (factory is null)
                return NotFound<string>("Factory not found.");

            if (request.EnergyAlertId.HasValue)
            {
                var alert = await _unitOfWork.EnergyAlerts
                    .GetTableNoTracking()
                    .FirstOrDefaultAsync(
                        a => a.Id == request.EnergyAlertId.Value,
                        cancellationToken);

                if (alert is null)
                    return NotFound<string>("Energy alert not found.");

                if (alert.FactoryId != request.FactoryId)
                    return BadRequest<string>(
                        "The energy alert does not belong to the specified factory.");
            }

            var recommendation = _mapper.Map<Recommendation>(request);

            recommendation.Id = Guid.NewGuid();
            recommendation.CreatedAtUtc = DateTime.UtcNow;
            recommendation.Status = RecommendationStatus.Pending;

            await _unitOfWork.Recommendations
                .AddAsync(recommendation, cancellationToken);

            await _unitOfWork.SaveChangesAsync();

            return Created<string>(
                recommendation.Id.ToString());
        }

        public async Task<Response<string>> Handle(
            UpdateRecommendationCommand request,
            CancellationToken cancellationToken)
        {
            var recommendation = await _unitOfWork.Recommendations
                .GetTableAsTracking()
                .FirstOrDefaultAsync(
                    r => r.Id == request.Id,
                    cancellationToken);

            if (recommendation is null)
                return NotFound<string>("Recommendation not found.");

            recommendation.Title = request.Title;
            recommendation.Description = request.Description;
            recommendation.Rationale = request.Rationale;
            recommendation.EstimatedSavingsAmount =
                request.EstimatedSavingsAmount;
            recommendation.CurrencyCode = request.CurrencyCode;
            recommendation.Status = request.Status;

            await _unitOfWork.SaveChangesAsync();

            return Success<string>(
                "Recommendation updated successfully.");
        }

        public async Task<Response<string>> Handle(
            DeleteRecommendationCommand request,
            CancellationToken cancellationToken)
        {
            var recommendation = await _unitOfWork.Recommendations
                .GetTableAsTracking()
                .FirstOrDefaultAsync(
                    r => r.Id == request.Id,
                    cancellationToken);

            if (recommendation is null)
                return NotFound<string>("Recommendation not found.");

            if (recommendation.SavingsSimulations.Any())
            {
                return BadRequest<string>(
                    "Cannot delete a recommendation that has savings simulations.");
            }

             _unitOfWork.Recommendations
                .Delete(recommendation);

            await _unitOfWork.SaveChangesAsync();

            return Deleted<string>();
        }
    }
}
