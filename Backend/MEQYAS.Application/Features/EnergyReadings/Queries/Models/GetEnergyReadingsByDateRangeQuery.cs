using MediatR;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Features.EnergyReadings.Queries.DTOS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyReadings.Queries.Models
{
    public class GetEnergyReadingsByDateRangeQuery
    : IRequest<Response<List<EnergyReadingDto>>>
    {
        public Guid EnergyMeterId { get; set; }

        public DateTime FromUtc { get; set; }

        public DateTime ToUtc { get; set; }

        public GetEnergyReadingsByDateRangeQuery(
            Guid energyMeterId,
            DateTime fromUtc,
            DateTime toUtc)
        {
            EnergyMeterId = energyMeterId;
            FromUtc = fromUtc;
            ToUtc = toUtc;
        }
    }
}
