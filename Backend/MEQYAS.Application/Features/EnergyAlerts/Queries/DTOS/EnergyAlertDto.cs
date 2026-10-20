using MEQYAS.Domain.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyAlerts.Queries.DTOS
{
    public class EnergyAlertDto
    {
        public Guid Id { get; set; }

        public Guid FactoryId { get; set; }

        public Guid? EnergyMeterId { get; set; }

        public AlertType AlertType { get; set; }

        public AlertSeverity Severity { get; set; }

        public string Title { get; set; } = string.Empty;

        public string Description { get; set; } = string.Empty;

        public decimal? ObservedValue { get; set; }

        public decimal? ExpectedValue { get; set; }

        public DateTime DetectedAtUtc { get; set; }

        public AlertStatus Status { get; set; }
    }
}
