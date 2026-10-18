using MediatR;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Features.EnergyMeters.Queries.DTOS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyMeters.Queries.Models
{
    public class GetEnergyMetersByFactoryIdQuery
    : IRequest<Response<List<EnergyMeterDto>>>
    {
        public Guid FactoryId { get; set; }
    }
}
