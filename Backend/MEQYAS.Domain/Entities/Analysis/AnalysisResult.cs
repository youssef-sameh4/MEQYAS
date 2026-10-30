using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Domain.Entities.Analysis
{
    public class AnalysisResult
    {
        public Guid Id { get; set; } = Guid.NewGuid();

        public Guid AnalysisRunId { get; set; }

        public Guid? EnergyReadingId { get; set; }

        // Model 1 - Anomaly Detection
        public bool IsAnomaly { get; set; }

        public decimal AnomalyPercentage { get; set; }

        public decimal RawScore { get; set; }

        // Model 2 - Power Factor Prediction
        public bool? IsLowPfRisk { get; set; }

        public decimal? RiskProbability { get; set; }

        public decimal? ActualPowerFactor { get; set; }

        public decimal? ComputedQPRatio { get; set; }

        public decimal? ThresholdUsed { get; set; }

        public string? Prediction { get; set; }

        public AnalysisRun AnalysisRun { get; set; } = null!;

        public EnergyReading? EnergyReading { get; set; }
    }
}
