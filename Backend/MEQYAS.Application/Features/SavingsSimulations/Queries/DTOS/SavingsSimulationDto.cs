using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.SavingsSimulations.Queries.DTOS
{
    public class SavingsSimulationDto
    {
        public Guid Id { get; set; }

        public Guid FactoryId { get; set; }

        public Guid? RecommendationId { get; set; }

        public string Name { get; set; } = string.Empty;

        public decimal BaselineConsumptionKwh { get; set; }

        public decimal ReductionPercentage { get; set; }

        public decimal BaselineCost { get; set; }

        public decimal ProjectedConsumptionKwh { get; set; }

        public decimal ProjectedCost { get; set; }

        public decimal EstimatedSavingsAmount { get; set; }

        public string CurrencyCode { get; set; } = string.Empty;

        public DateTime CreatedAtUtc { get; set; }
    }
}
