using MEQYAS.Domain.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.Recommendations.Queries.DTOs
{
    public class RecommendationDto
    {
        public Guid Id { get; set; }

        public Guid FactoryId { get; set; }

        public Guid? EnergyAlertId { get; set; }

        public string Title { get; set; } = string.Empty;

        public string Description { get; set; } = string.Empty;

        public string Rationale { get; set; } = string.Empty;

        public decimal? EstimatedSavingsAmount { get; set; }

        public string CurrencyCode { get; set; } = string.Empty;

        public RecommendationStatus Status { get; set; }

        public DateTime CreatedAtUtc { get; set; }
    }
}
