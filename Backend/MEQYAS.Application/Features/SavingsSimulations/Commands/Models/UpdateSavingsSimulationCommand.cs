using MediatR;
using MEQYAS.Application.Bases;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.SavingsSimulations.Commands.Models
{
    public class UpdateSavingsSimulationCommand : IRequest<Response<string>>
    {
        public Guid Id { get; set; }

        public Guid FactoryId { get; set; }

        public Guid? RecommendationId { get; set; }

        public string Name { get; set; } = string.Empty;

        public decimal BaselineConsumptionKwh { get; set; }

        public decimal ReductionPercentage { get; set; }

        public decimal BaselineCost { get; set; }

        public string CurrencyCode { get; set; } = string.Empty;
    }
}
