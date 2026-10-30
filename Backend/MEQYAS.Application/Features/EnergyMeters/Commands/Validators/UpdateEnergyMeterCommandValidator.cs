using FluentValidation;
using MEQYAS.Application.Features.EnergyMeters.Commands.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyMeters.Commands.Validators
{
    public class UpdateEnergyMeterCommandValidator
    : AbstractValidator<UpdateEnergyMeterCommand>
    {
        public UpdateEnergyMeterCommandValidator()
        {
            RuleFor(x => x.Id)
                .NotEmpty()
                .WithMessage("Energy meter ID is required.");

            RuleFor(x => x.Name)
                .NotEmpty()
                .WithMessage("Meter name is required.")
                .MaximumLength(200)
                .WithMessage("Meter name cannot exceed 200 characters.");

            RuleFor(x => x.Code)
                .NotEmpty()
                .WithMessage("Meter code is required.")
                .MaximumLength(50)
                .WithMessage("Meter code cannot exceed 50 characters.");

            RuleFor(x => x.Unit)
                .NotEmpty()
                .WithMessage("Meter unit is required.")
                .MaximumLength(20)
                .WithMessage("Meter unit cannot exceed 20 characters.");

            RuleFor(x => x.MeterType)
                .IsInEnum()
                .WithMessage("Invalid meter type.");
        }
    }
}
