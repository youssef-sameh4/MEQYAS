using FluentValidation;
using MEQYAS.Application.Features.EnergyAlerts.Commands.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyAlerts.Commands.Validators
{
    public class CreateEnergyAlertValidator : AbstractValidator<CreateEnergyAlertCommand>
    {
        public CreateEnergyAlertValidator()
        {
            RuleFor(x => x.FactoryId)
                .NotEmpty()
                .WithMessage("Factory ID is required.");

            RuleFor(x => x.Title)
                .NotEmpty()
                .WithMessage("Alert title is required.")
                .MaximumLength(200)
                .WithMessage("Alert title must not exceed 200 characters.");

            RuleFor(x => x.Description)
                .NotEmpty()
                .WithMessage("Alert description is required.")
                .MaximumLength(1000)
                .WithMessage("Alert description must not exceed 1000 characters.");

            RuleFor(x => x.DetectedAtUtc)
                .NotEmpty()
                .WithMessage("Detection date is required.");

            RuleFor(x => x.ObservedValue)
                .GreaterThanOrEqualTo(0)
                .When(x => x.ObservedValue.HasValue)
                .WithMessage("Observed value cannot be negative.");

            RuleFor(x => x.ExpectedValue)
                .GreaterThanOrEqualTo(0)
                .When(x => x.ExpectedValue.HasValue)
                .WithMessage("Expected value cannot be negative.");

            RuleFor(x => x)
                .Must(x => !x.ObservedValue.HasValue
                           || !x.ExpectedValue.HasValue
                           || x.ObservedValue != x.ExpectedValue)
                .WithMessage("Observed and expected values should not be equal.");
        }
    }
}
