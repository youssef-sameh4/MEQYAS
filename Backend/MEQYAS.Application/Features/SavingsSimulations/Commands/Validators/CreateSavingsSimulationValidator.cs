using FluentValidation;
using MEQYAS.Application.Features.SavingsSimulations.Commands.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.SavingsSimulations.Commands.Validators
{
    public class CreateSavingsSimulationValidator
      : AbstractValidator<CreateSavingsSimulationCommand>
    {
        public CreateSavingsSimulationValidator()
        {
            RuleFor(x => x.FactoryId)
                .NotEmpty()
                .WithMessage("Factory ID is required.");

            RuleFor(x => x.RecommendationId)
                .Must(id => !id.HasValue || id.Value != Guid.Empty)
                .WithMessage("Recommendation ID must be valid.");

            RuleFor(x => x.Name)
                .NotEmpty()
                .WithMessage("Simulation name is required.")
                .MaximumLength(200);

            RuleFor(x => x.BaselineConsumptionKwh)
                .GreaterThanOrEqualTo(0)
                .WithMessage("Baseline consumption cannot be negative.");

            RuleFor(x => x.ReductionPercentage)
                .InclusiveBetween(0, 100)
                .WithMessage("Reduction percentage must be between 0 and 100.");

            RuleFor(x => x.BaselineCost)
                .GreaterThanOrEqualTo(0)
                .WithMessage("Baseline cost cannot be negative.");

            RuleFor(x => x.CurrencyCode)
                .NotEmpty()
                .Length(3)
                .WithMessage("Currency code must contain exactly 3 characters.");
        }
    }
}
