using FluentValidation;
using MEQYAS.Application.Features.EnergyAlerts.Commands.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyAlerts.Commands.Validators
{
    public class UpdateEnergyAlertValidator : AbstractValidator<UpdateEnergyAlertCommand>
    {
        public UpdateEnergyAlertValidator()
        {
            RuleFor(x => x.Id)
                .NotEmpty()
                .WithMessage("Alert ID is required.");

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
        }
    }
}
