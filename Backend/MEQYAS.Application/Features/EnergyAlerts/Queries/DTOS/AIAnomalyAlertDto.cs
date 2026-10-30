using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyAlerts.Queries.DTOS
{
    public class AIAnomalyAlertDto
    {
        public Guid Id { get; set; }

        public string Title { get; set; } = string.Empty;

        public string Description { get; set; } = string.Empty;

        public decimal AnomalyPercentage { get; set; }

        public string Severity { get; set; } = string.Empty;

        public DateTime DetectedAtUtc { get; set; }

        public string Status { get; set; } = string.Empty;
    }
}
