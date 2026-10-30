using MediatR;
using MEQYAS.Application.Abstractions.Interfaces;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Bases.MEQYAS.Application.Bases;
using MEQYAS.Application.Features.Analysis.Commands.Models;
using MEQYAS.Application.Features.Analysis.DTOs;
using MEQYAS.Application.Features.Analysis.Interfaces;
using MEQYAS.Domain.Entities;
using MEQYAS.Domain.Entities.Analysis;
using MEQYAS.Domain.Enums;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.Analysis.Commands.Handlers
{
    public class RunDemoAnalysisCommandHandler
        : ResponseHandler,
          IRequestHandler<
              RunDemoAnalysisCommand,
              Response<DemoAnalysisResponseDto>>
    {
        private const int MaxReadings = 100;
        private const decimal DefaultThreshold = 50;

        private readonly IUnitOfWork _unitOfWork;
        private readonly IDemoDatasetService _demoDatasetService;
        private readonly IAIEnergyAnalysisService _aiEnergyAnalysisService;

        public RunDemoAnalysisCommandHandler(
            IUnitOfWork unitOfWork,
            IDemoDatasetService demoDatasetService,
            IAIEnergyAnalysisService aiEnergyAnalysisService)
        {
            _unitOfWork = unitOfWork;
            _demoDatasetService = demoDatasetService;
            _aiEnergyAnalysisService = aiEnergyAnalysisService;
        }

        public async Task<Response<DemoAnalysisResponseDto>> Handle(
            RunDemoAnalysisCommand request,
            CancellationToken cancellationToken)
        {
            var startedAtUtc = DateTime.UtcNow;

            // 1. Load demo readings
            var allReadings = await _demoDatasetService.LoadReadingsAsync(
                cancellationToken);

            if (allReadings.Count == 0)
            {
                return BadRequest<DemoAnalysisResponseDto>(
                    "The demo dataset contains no readings.");
            }

            // 2. Select a random sample of readings
            var readings = allReadings
                .OrderBy(_ => Random.Shared.Next())
                .Take(MaxReadings)
                .ToList();

            // 3. Send readings to the AI service
            var aiRequest = new AIBatchPredictionRequestDto
            {
                Readings = readings,
                Threshold = DefaultThreshold
            };

            var aiResponse = await _aiEnergyAnalysisService.PredictBatchAsync(
                aiRequest,
                cancellationToken);

            if (aiResponse.Results == null ||
                aiResponse.Results.Count != readings.Count)
            {
                return BadRequest<DemoAnalysisResponseDto>(
                    "The number of AI results does not match the number of readings.");
            }

            if (aiResponse.TotalReadings != readings.Count)
            {
                return BadRequest<DemoAnalysisResponseDto>(
                    "The AI API returned an unexpected total reading count.");
            }

            var completedAtUtc = DateTime.UtcNow;

            // 4. Create the analysis run
            var analysisRun = new AnalysisRun
            {
                Id = Guid.NewGuid(),
                FactoryId = null,
                DataSource = AnalysisDataSource.DemoDataset,
                Status = AnalysisStatus.Completed,
                TotalReadings = aiResponse.TotalReadings,
                AnomaliesCount = aiResponse.AnomaliesCount,
                NormalCount = aiResponse.NormalCount,
                AnomalyRatePct = aiResponse.AnomalyRatePct,
                StartedAtUtc = startedAtUtc,
                CompletedAtUtc = completedAtUtc
            };

            await _unitOfWork.AnalysisRuns.AddAsync(
                analysisRun,
                cancellationToken);

            // 5. Create analysis results
            var analysisResults = aiResponse.Results
                .Select(result => new AnalysisResult
                {
                    Id = Guid.NewGuid(),
                    AnalysisRunId = analysisRun.Id,
                    EnergyReadingId = null,
                    IsAnomaly = result.IsAnomaly,
                    AnomalyPercentage = result.AnomalyPercentage,
                    RawScore = result.RawScore
                })
                .ToList();

            await _unitOfWork.AnalysisResults.AddRangeAsync(
                analysisResults,
                cancellationToken);

            // 6. Create alerts for anomalous results only
            var alerts = aiResponse.Results
                .Select((result, index) => new
                {
                    Result = result,
                    AnalysisResult = analysisResults[index]
                })
                .Where(item => item.Result.IsAnomaly)
                .Select(item => new EnergyAlert
                {
                    Id = Guid.NewGuid(),
                    FactoryId = null,
                    AnalysisResultId = item.AnalysisResult.Id,
                    AlertType = AlertType.UnusualConsumption,

                    Severity = item.Result.AnomalyPercentage switch
                    {
                        < 30m => AlertSeverity.Low,
                        < 60m => AlertSeverity.Medium,
                        _ => AlertSeverity.High
                    },

                    Title = "Energy Anomaly Detected",
                    Description = item.Result.Message,
                    DetectedAtUtc = completedAtUtc,
                    Status = AlertStatus.Active
                })
                .ToList();

            if (alerts.Count > 0)
            {
                await _unitOfWork.EnergyAlerts.AddRangeAsync(
                    alerts,
                    cancellationToken);
            }

            // 7. Save analysis results and alerts
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            // 8. Build response
            var response = new DemoAnalysisResponseDto
            {
                AnalysisRunId = analysisRun.Id,
                DataSource = "DemoDataset",
                Status = "Completed",
                TotalReadings = aiResponse.TotalReadings,
                AnomaliesCount = aiResponse.AnomaliesCount,
                NormalCount = aiResponse.NormalCount,
                AnomalyRatePct = aiResponse.AnomalyRatePct,
                AverageAnomalyPercentage =
                    aiResponse.AverageAnomalyPercentage,
                StartedAtUtc = startedAtUtc,
                CompletedAtUtc = completedAtUtc,

                Results = aiResponse.Results
                    .Select((result, index) => new DemoAnalysisResultDto
                    {
                        Id = analysisResults[index].Id,
                        EnergyReadingId = null,
                        IsAnomaly = result.IsAnomaly,
                        AnomalyPercentage = result.AnomalyPercentage,
                        RawScore = result.RawScore,
                        Prediction = result.Prediction,
                        Message = result.Message
                    })
                    .ToList()
            };

            return Success(response);
        }
    }
}