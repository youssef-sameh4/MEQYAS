using FluentValidation;
using MEQYAS.Application.Features.EnergyReadings.Commands.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyReadings.Commands.Validators
{
    public class CreateEnergyReadingCommandValidator
      : AbstractValidator<CreateEnergyReadingCommand>
    {
        public CreateEnergyReadingCommandValidator()
        {
            RuleFor(x => x.EnergyMeterId)
                .NotEmpty()
                .WithMessage("Energy Meter ID is required.");

            RuleFor(x => x.RecordedAtUtc)
                .NotEmpty()
                .WithMessage("Recorded date is required.");

            RuleFor(x => x.Value)
                .GreaterThanOrEqualTo(0)
                .WithMessage("Reading value cannot be negative.");

            RuleFor(x => x.ReadingType)
                .IsInEnum()
                .WithMessage("Invalid reading type.");

            RuleFor(x => x.Unit)
                .NotEmpty()
                .WithMessage("Unit is required.")
                .MaximumLength(20)
                .WithMessage("Unit cannot exceed 20 characters.");
        }
    }
}
