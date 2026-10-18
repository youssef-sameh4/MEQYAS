using FluentValidation;
using MEQYAS.Application.Features.EnergyAlerts.Commands.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyAlerts.Commands.Validators
{
    public class DeleteEnergyAlertValidator : AbstractValidator<DeleteEnergyAlertCommand>
    {
        public DeleteEnergyAlertValidator()
        {
            RuleFor(x => x.Id)
                .NotEmpty()
                .WithMessage("Alert ID is required.");
        }
    }
}
