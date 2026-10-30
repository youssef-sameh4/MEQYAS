using FluentValidation;
using MEQYAS.Application.Features.SavingsSimulations.Commands.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.SavingsSimulations.Commands.Validators
{
    public class DeleteSavingsSimulationValidator
    : AbstractValidator<DeleteSavingsSimulationCommand>
    {
        public DeleteSavingsSimulationValidator()
        {
            RuleFor(x => x.Id)
                .NotEmpty()
                .WithMessage("Simulation ID is required.");
        }
    }
}
