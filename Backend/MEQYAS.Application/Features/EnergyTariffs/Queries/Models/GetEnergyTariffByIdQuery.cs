using MediatR;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Features.EnergyTariffs.Queries.DTOS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyTariffs.Queries.Models
{
    public class GetEnergyTariffByIdQuery:IRequest<Response<EnergyTariffDto>>
    {
        public Guid Id { set; get; }

        public GetEnergyTariffByIdQuery(Guid id)
        {
            Id = id;
        }
    }
}
