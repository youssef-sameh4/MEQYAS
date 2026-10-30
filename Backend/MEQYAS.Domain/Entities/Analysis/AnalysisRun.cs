using MEQYAS.Domain.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Domain.Entities.Analysis
{
    public class AnalysisRun
    {
        public Guid Id { get; set; } = Guid.NewGuid();

        public Guid? FactoryId { get; set; }

        public AnalysisType AnalysisType { get; set; }

        public AnalysisDataSource DataSource { get; set; }

        public AnalysisStatus Status { get; set; }

        public int TotalReadings { get; set; }

        public int AnomaliesCount { get; set; }

        public int NormalCount { get; set; }

        public decimal AnomalyRatePct { get; set; }

        // Power Factor summary
        public int? LowPfRiskCount { get; set; }

        public decimal? RiskRatePct { get; set; }

        public DateTime StartedAtUtc { get; set; }

        public DateTime? CompletedAtUtc { get; set; }

        public Factory? Factory { get; set; }

        public ICollection<AnalysisResult> Results { get; set; }
            = new List<AnalysisResult>();
    }
}
