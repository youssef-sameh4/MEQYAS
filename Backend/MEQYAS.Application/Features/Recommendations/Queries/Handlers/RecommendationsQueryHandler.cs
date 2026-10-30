using AutoMapper;
using MediatR;
using MEQYAS.Application.Abstractions.Interfaces;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Bases.MEQYAS.Application.Bases;
using MEQYAS.Application.Features.Recommendations.Queries.DTOs;
using MEQYAS.Application.Features.Recommendations.Queries.Models;
using MEQYAS.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace MEQYAS.Application.Features.Recommendations.Queries.Handlers;

public class RecommendationsQueryHandler :
    ResponseHandler,
    IRequestHandler<GetAllRecommendationsQuery, Response<List<RecommendationDto>>>,
    IRequestHandler<GetRecommendationByIdQuery, Response<RecommendationDto>>,
    IRequestHandler<GetRecommendationsByFactoryIdQuery, Response<List<RecommendationDto>>>
{
    private readonly IUnitOfWork _unitOfWork;
    private readonly IMapper _mapper;

    public RecommendationsQueryHandler(
        IUnitOfWork unitOfWork,
        IMapper mapper)
    {
        _unitOfWork = unitOfWork;
        _mapper = mapper;
    }

    public async Task<Response<List<RecommendationDto>>> Handle(
        GetAllRecommendationsQuery request,
        CancellationToken cancellationToken)
    {
        var recommendations = await _unitOfWork.Recommendations
            .GetTableNoTracking()
            .OrderByDescending(r => r.CreatedAtUtc)
            .ToListAsync(cancellationToken);

        var result = _mapper.Map<List<RecommendationDto>>(recommendations);

        return Success(result);
    }

    public async Task<Response<RecommendationDto>> Handle(
        GetRecommendationByIdQuery request,
        CancellationToken cancellationToken)
    {
        var recommendation = await _unitOfWork.Recommendations
            .GetTableNoTracking()
            .FirstOrDefaultAsync(
                r => r.Id == request.Id,
                cancellationToken);

        if (recommendation is null)
            return NotFound<RecommendationDto>("Recommendation not found.");

        var result = _mapper.Map<RecommendationDto>(recommendation);

        return Success(result);
    }

    public async Task<Response<List<RecommendationDto>>> Handle(
        GetRecommendationsByFactoryIdQuery request,
        CancellationToken cancellationToken)
    {
        var factoryExists = await _unitOfWork.Factories
            .GetTableNoTracking()
            .AnyAsync(
                f => f.Id == request.FactoryId,
                cancellationToken);

        if (!factoryExists)
            return NotFound<List<RecommendationDto>>("Factory not found.");

        var recommendations = await _unitOfWork.Recommendations
            .GetTableNoTracking()
            .Where(r => r.FactoryId == request.FactoryId)
            .OrderByDescending(r => r.CreatedAtUtc)
            .ToListAsync(cancellationToken);

        var result = _mapper.Map<List<RecommendationDto>>(recommendations);

        return Success(result);
    }
}
