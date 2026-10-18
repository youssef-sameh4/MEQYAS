using MediatR;
using MEQYAS.Application.Bases;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyAlerts.Commands.Models
{
    public class DeleteEnergyAlertCommand : IRequest<Response<string>>
    {
        public Guid Id { get; set; }

        public DeleteEnergyAlertCommand(Guid id)
        {
            Id = id;
        }
    }
}
