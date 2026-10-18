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
    public class GetEnergyReadingsByMeterIdQuery
    : IRequest<Response<List<EnergyReadingDto>>>
    {
        public Guid EnergyMeterId { get; set; }

        public GetEnergyReadingsByMeterIdQuery(Guid energyMeterId)
        {
            EnergyMeterId = energyMeterId;
        }
    }
}
