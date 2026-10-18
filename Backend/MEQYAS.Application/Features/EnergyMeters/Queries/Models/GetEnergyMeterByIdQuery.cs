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

    public class GetEnergyMeterByIdQuery : IRequest<Response<EnergyMeterDto>>
    {
        public Guid Id { get; set; }
    }
}
