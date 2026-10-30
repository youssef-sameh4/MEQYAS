using AutoMapper;
using MediatR;
using MEQYAS.Application.Abstractions.Interfaces;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Bases.MEQYAS.Application.Bases;
using MEQYAS.Application.Features.EnergyAlerts.Queries.DTOS;
using MEQYAS.Application.Features.EnergyAlerts.Queries.Models;
using MEQYAS.Domain.Enums;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyAlerts.Queries.Handlers
{
    public class EnergyAlertsQueryHandler : ResponseHandler,
       IRequestHandler<GetAllEnergyAlertsQuery, Response<List<EnergyAlertDto>>>,
       IRequestHandler<GetEnergyAlertByIdQuery, Response<EnergyAlertDto>>,
       IRequestHandler<GetEnergyAlertsByFactoryIdQuery, Response<List<EnergyAlertDto>>>,
       IRequestHandler<GetAIAnomalyAlertsQuery, Response<List<AIAnomalyAlertDto>>>
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IMapper _mapper;

        public EnergyAlertsQueryHandler(
            IUnitOfWork unitOfWork,
            IMapper mapper)
        {
            _unitOfWork = unitOfWork;
            _mapper = mapper;
        }

        public async Task<Response<List<EnergyAlertDto>>> Handle(
            GetAllEnergyAlertsQuery request,
            CancellationToken cancellationToken)
        {
            var alerts = await _unitOfWork.EnergyAlerts
                .GetTableNoTracking()
                .OrderByDescending(a => a.DetectedAtUtc)
                .ToListAsync(cancellationToken);

            var result = _mapper.Map<List<EnergyAlertDto>>(alerts);

            return Success(result);
        }

        public async Task<Response<EnergyAlertDto>> Handle(
            GetEnergyAlertByIdQuery request,
            CancellationToken cancellationToken)
        {
            var alert = await _unitOfWork.EnergyAlerts
                .GetTableNoTracking()
                .FirstOrDefaultAsync(
                    a => a.Id == request.Id,
                    cancellationToken);

            if (alert is null)
                return NotFound<EnergyAlertDto>("Energy alert not found.");

            var result = _mapper.Map<EnergyAlertDto>(alert);

            return Success(result);
        }

        public async Task<Response<List<EnergyAlertDto>>> Handle(
            GetEnergyAlertsByFactoryIdQuery request,
            CancellationToken cancellationToken)
        {
            var alerts = await _unitOfWork.EnergyAlerts
                .GetTableNoTracking()
                .Where(a => a.FactoryId == request.FactoryId)
                .OrderByDescending(a => a.DetectedAtUtc)
                .ToListAsync(cancellationToken);

            var result = _mapper.Map<List<EnergyAlertDto>>(alerts);

            return Success(result);
        }

        public async Task<Response<List<AIAnomalyAlertDto>>> Handle(
    GetAIAnomalyAlertsQuery request,
    CancellationToken cancellationToken)
        {
            // 1. Get the latest analysis run
            var latestAnalysisRunId = await _unitOfWork.AnalysisRuns
                .GetTableNoTracking()
                .Where(run => run.Status == AnalysisStatus.Completed)
                .OrderByDescending(run => run.CompletedAtUtc)
                .Select(run => (Guid?)run.Id)
                .FirstOrDefaultAsync(cancellationToken);

            // 2. No completed analysis found
            if (latestAnalysisRunId == null)
            {
                return Success(new List<AIAnomalyAlertDto>());
            }

            // 3. Get only High and Medium alerts from the latest analysis
            var alerts = await _unitOfWork.EnergyAlerts
                .GetTableNoTracking()
                .Where(alert =>
                    alert.AnalysisResult != null &&
                    alert.AnalysisResult.AnalysisRunId == latestAnalysisRunId.Value &&
                    (alert.Severity == AlertSeverity.High ||
                     alert.Severity == AlertSeverity.Medium))
                .OrderByDescending(alert => alert.Severity)
                .ThenByDescending(alert => alert.DetectedAtUtc)
                .Select(alert => new AIAnomalyAlertDto
                {
                    Id = alert.Id,
                    Title = alert.Title,
                    Description = alert.Description,
                    AnomalyPercentage = alert.AnalysisResult != null
                        ? alert.AnalysisResult.AnomalyPercentage
                        : 0m,
                    Severity = alert.Severity.ToString(),
                    DetectedAtUtc = alert.DetectedAtUtc,
                    Status = alert.Status.ToString()
                })
                .ToListAsync(cancellationToken);

            return Success(alerts);
        }
    }
}
