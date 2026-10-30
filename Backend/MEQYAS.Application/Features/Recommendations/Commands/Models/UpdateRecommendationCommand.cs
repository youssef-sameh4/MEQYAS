using MediatR;
using MEQYAS.Application.Bases;
using MEQYAS.Domain.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.Recommendations.Commands.Models
{
    public class UpdateRecommendationCommand : IRequest<Response<string>>
    {
        public Guid Id { get; set; }

        public string Title { get; set; } = string.Empty;

        public string Description { get; set; } = string.Empty;

        public string Rationale { get; set; } = string.Empty;

        public decimal? EstimatedSavingsAmount { get; set; }

        public string CurrencyCode { get; set; } = string.Empty;

        public RecommendationStatus Status { get; set; }
    }
}
