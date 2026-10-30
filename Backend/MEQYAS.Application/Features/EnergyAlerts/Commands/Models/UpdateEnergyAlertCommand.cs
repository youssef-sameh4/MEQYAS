using MediatR;
using MEQYAS.Application.Bases;
using MEQYAS.Domain.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyAlerts.Commands.Models
{
    public class UpdateEnergyAlertCommand : IRequest<Response<string>>
    {
        public Guid Id { get; set; }

        public AlertSeverity Severity { get; set; }

        public string Title { get; set; } = string.Empty;

        public string Description { get; set; } = string.Empty;

        public AlertStatus Status { get; set; }
    }
}
