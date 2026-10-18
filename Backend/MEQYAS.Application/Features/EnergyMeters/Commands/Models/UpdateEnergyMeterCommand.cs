using MediatR;
using MEQYAS.Application.Bases;
using MEQYAS.Domain.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyMeters.Commands.Models
{
    public class UpdateEnergyMeterCommand : IRequest<Response<string>>
    {
        public Guid Id { get; set; }

        public string Name { get; set; } = string.Empty;

        public string Code { get; set; } = string.Empty;

        public MeterType MeterType { get; set; }

        public string Unit { get; set; } = string.Empty;
    }
}
