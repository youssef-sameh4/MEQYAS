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
    public class GetEnergyReadingByIdQuery : IRequest<Response<EnergyReadingDto>>
    {
        public Guid Id { get; set; }

        public GetEnergyReadingByIdQuery(Guid id)
        {
            Id = id;
        }
    }
}
