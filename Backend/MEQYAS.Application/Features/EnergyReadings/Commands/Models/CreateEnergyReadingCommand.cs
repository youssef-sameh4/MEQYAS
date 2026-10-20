using MediatR;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Features.EnergyReadings.Queries.DTOS;
using MEQYAS.Domain.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyReadings.Commands.Models
{
    public class CreateEnergyReadingCommand : IRequest<Response<string>>
    {
        public Guid EnergyMeterId { get; set; }

        public DateTime RecordedAtUtc { get; set; }

        public decimal Value { get; set; }

        public ReadingType ReadingType { get; set; }

        public string Unit { get; set; } = string.Empty;
    }
}
