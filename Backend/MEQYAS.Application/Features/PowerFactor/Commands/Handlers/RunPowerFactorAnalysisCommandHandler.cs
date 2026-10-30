using MediatR;
using MEQYAS.Application.Abstractions.Interfaces;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Bases.MEQYAS.Application.Bases;
using MEQYAS.Application.Features.PowerFactor.Commands.Models;
using MEQYAS.Application.Features.PowerFactor.DTOs;
using MEQYAS.Application.Features.PowerFactor.Interfaces;
using MEQYAS.Domain.Entities.Analysis;
using MEQYAS.Domain.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.PowerFactor.Commands.Handlers
{
    public class RunPowerFactorAnalysisCommandHandler
     : ResponseHandler,
       IRequestHandler<
           RunPowerFactorAnalysisCommand,
           Response<PowerFactorAnalysisResponseDto>>
    {
        private const int SampleSize = 100;
        private const decimal DefaultThreshold = 0.5m;

        private readonly IUnitOfWork _unitOfWork;
        private readonly IPowerFactorDatasetService _datasetService;
        private readonly IPowerFactorAnalysisService _analysisService;

        public RunPowerFactorAnalysisCommandHandler(
            IUnitOfWork unitOfWork,
            IPowerFactorDatasetService datasetService,
            IPowerFactorAnalysisService analysisService)
        {
            _unitOfWork = unitOfWork;
            _datasetService = datasetService;
            _analysisService = analysisService;
        }

        public async Task<Response<PowerFactorAnalysisResponseDto>> Handle(
            RunPowerFactorAnalysisCommand request,
            CancellationToken cancellationToken)
        {
            var startedAtUtc = DateTime.UtcNow;

            // 1. Load random sample from Power Factor dataset
            var readings = await _datasetService.GetRandomReadingsAsync(
                SampleSize,
                cancellationToken);

            if (readings.Count == 0)
            {
                return BadRequest<PowerFactorAnalysisResponseDto>(
                    "The Power Factor dataset contains no readings.");
            }

            // 2. Send readings to AI service
            var aiRequest = new PowerFactorBatchPredictionRequestDto
            {
                Readings = readings,
                Threshold = DefaultThreshold
            };

            var aiResponse = await _analysisService.PredictBatchAsync(
                aiRequest,
                cancellationToken);

            if (aiResponse.Results == null ||
                aiResponse.Results.Count != readings.Count)
            {
                return BadRequest<PowerFactorAnalysisResponseDto>(
                    "The number of AI results does not match the number of readings.");
            }

            if (aiResponse.Total != readings.Count)
            {
                return BadRequest<PowerFactorAnalysisResponseDto>(
                    "The AI API returned an unexpected total reading count.");
            }

            var completedAtUtc = DateTime.UtcNow;

            // 3. Create AnalysisRun
            var analysisRun = new AnalysisRun
            {
                Id = Guid.NewGuid(),
                FactoryId = null,

                AnalysisType = AnalysisType.PowerFactorPrediction,
                DataSource = AnalysisDataSource.DemoDataset,
                Status = AnalysisStatus.Completed,

                TotalReadings = aiResponse.Total,

                LowPfRiskCount = aiResponse.LowPfRiskCount,
                RiskRatePct = aiResponse.RiskRatePct,

                StartedAtUtc = startedAtUtc,
                CompletedAtUtc = completedAtUtc
            };

            await _unitOfWork.AnalysisRuns.AddAsync(
                analysisRun,
                cancellationToken);

            // 4. Create AnalysisResults
            var analysisResults = aiResponse.Results
                .Select(result => new AnalysisResult
                {
                    Id = Guid.NewGuid(),
                    AnalysisRunId = analysisRun.Id,
                    EnergyReadingId = null,

                    // Model 2
                    IsLowPfRisk = result.IsLowPfRisk,
                    RiskProbability = result.RiskProbability,
                    ActualPowerFactor = result.ActualPowerFactor,
                    ComputedQPRatio = result.ComputedQPRatio,
                    ThresholdUsed = result.ThresholdUsed,
                    Prediction = result.Prediction,

                    // Model 1 fields
                    IsAnomaly = false,
                    AnomalyPercentage = 0,
                    RawScore = 0
                })
                .ToList();

            await _unitOfWork.AnalysisResults.AddRangeAsync(
                analysisResults,
                cancellationToken);

            // 5. Save analysis
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            // 6. Build response
            var response = new PowerFactorAnalysisResponseDto
            {
                TotalReadings = aiResponse.Total,
                LowPfRiskCount = aiResponse.LowPfRiskCount,
                NormalCount = aiResponse.NormalCount,
                RiskRatePct = aiResponse.RiskRatePct,

                Results = aiResponse.Results
                    .Select(result => new PowerFactorPredictionResultDto
                    {
                        Prediction = result.Prediction,
                        IsLowPfRisk = result.IsLowPfRisk,
                        RiskProbability = result.RiskProbability,
                        RiskPercentage = result.RiskPercentage,
                        ThresholdUsed = result.ThresholdUsed,
                        ActualPowerFactor = result.ActualPowerFactor,
                        ComputedQPRatio = result.ComputedQPRatio,
                        Message = result.Message
                    })
                    .ToList()
            };

            return Success(response);
        }
    }
    }
