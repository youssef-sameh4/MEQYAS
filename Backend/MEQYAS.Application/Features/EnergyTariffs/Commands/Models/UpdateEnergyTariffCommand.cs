using MediatR;
using MEQYAS.Application.Bases;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyTariffs.Commands.Models
{
    public class UpdateEnergyTariffCommand:IRequest<Response<string>>
    {
        public Guid Id { get; set; }
        public Guid FactoryId { get; set; }
        public string Name { get; set; } = string.Empty;
        public decimal PricePerKwh { get; set; }
        public string CurrencyCode { get; set; } = string.Empty;
        public DateTime EffectiveFrom { get; set; }
        public DateTime? EffectiveTo { get; set; }
    }
}
