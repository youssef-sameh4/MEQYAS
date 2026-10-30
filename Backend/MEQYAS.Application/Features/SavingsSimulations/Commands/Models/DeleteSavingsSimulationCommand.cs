using MediatR;
using MEQYAS.Application.Bases;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.SavingsSimulations.Commands.Models
{
    public class DeleteSavingsSimulationCommand : IRequest<Response<string>>
    {
        public Guid Id { get; set; }
    }
}
