using MediatR;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Features.Recommendations.Queries.DTOs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.Recommendations.Queries.Models
{
    public class GetRecommendationsByFactoryIdQuery : IRequest<Response<List<RecommendationDto>>>
    {
        public Guid FactoryId { get; set; }
    }
}
