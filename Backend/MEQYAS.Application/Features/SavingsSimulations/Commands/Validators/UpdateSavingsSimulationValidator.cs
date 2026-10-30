using FluentValidation;
using MEQYAS.Application.Features.SavingsSimulations.Commands.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.SavingsSimulations.Commands.Validators
{
    public class UpdateSavingsSimulationValidator
    : AbstractValidator<UpdateSavingsSimulationCommand>
    {
        public UpdateSavingsSimulationValidator()
        {
            RuleFor(x => x.Id)
                .NotEmpty();

            RuleFor(x => x.FactoryId)
                .NotEmpty();

            RuleFor(x => x.RecommendationId)
                .Must(id => !id.HasValue || id.Value != Guid.Empty);

            RuleFor(x => x.Name)
                .NotEmpty()
                .MaximumLength(200);

            RuleFor(x => x.BaselineConsumptionKwh)
                .GreaterThanOrEqualTo(0);

            RuleFor(x => x.ReductionPercentage)
                .InclusiveBetween(0, 100);

            RuleFor(x => x.BaselineCost)
                .GreaterThanOrEqualTo(0);

            RuleFor(x => x.CurrencyCode)
                .NotEmpty()
                .Length(3);
        }
    }
}
