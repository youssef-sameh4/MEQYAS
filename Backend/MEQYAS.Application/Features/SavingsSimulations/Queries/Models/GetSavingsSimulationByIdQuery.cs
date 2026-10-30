using MediatR;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Features.SavingsSimulations.Queries.DTOS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.SavingsSimulations.Queries.Models
{
    public class GetSavingsSimulationByIdQuery
    : IRequest<Response<SavingsSimulationDto>>
    {
        public Guid Id { get; set; }
    }
}
