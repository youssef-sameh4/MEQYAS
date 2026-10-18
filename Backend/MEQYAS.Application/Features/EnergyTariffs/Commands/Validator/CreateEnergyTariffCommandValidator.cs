using FluentValidation;
using MEQYAS.Application.Features.EnergyTariffs.Commands.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyTariffs.Commands.Validator
{
    public class CreateEnergyTariffCommandValidator:AbstractValidator<CreateEnergyTariffCommand>
    {
        public CreateEnergyTariffCommandValidator()
        {
            RuleFor(x => x.FactoryId)
                .NotEmpty()
                .WithMessage("FactoryId is required.");

            RuleFor(x => x.Name)
                .NotEmpty()
                .WithMessage("Name is required.")
                .MaximumLength(100)
                .WithMessage("Name must not exceed 100 characters.");

            RuleFor(x => x.PricePerKwh)
                .GreaterThanOrEqualTo(0)
                .WithMessage("PricePerKwh must be greater than or equal to zero.");

            RuleFor(x => x.CurrencyCode)
                .NotEmpty()
                .WithMessage("CurrencyCode is required.")
                .Length(3)
                .WithMessage("CurrencyCode must be exactly 3 characters.");

            RuleFor(x => x.EffectiveFrom)
                .NotEmpty()
                .WithMessage("EffectiveFrom is required.");

            RuleFor(x => x.EffectiveTo)
                .Must((command, effectiveTo) =>
                    !effectiveTo.HasValue || effectiveTo.Value > command.EffectiveFrom)
                .WithMessage("EffectiveTo must be later than EffectiveFrom.");
        }
    }
}
