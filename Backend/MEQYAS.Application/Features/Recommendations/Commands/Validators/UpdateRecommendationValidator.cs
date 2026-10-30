using FluentValidation;
using MEQYAS.Application.Features.Recommendations.Commands.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.Recommendations.Commands.Validators
{
    public class UpdateRecommendationValidator : AbstractValidator<UpdateRecommendationCommand>
    {
        public UpdateRecommendationValidator()
        {
            RuleFor(x => x.Id)
                .NotEmpty()
                .WithMessage("Recommendation ID is required.");

            RuleFor(x => x.Title)
                .NotEmpty()
                .WithMessage("Recommendation title is required.")
                .MaximumLength(200)
                .WithMessage("Recommendation title must not exceed 200 characters.");

            RuleFor(x => x.Description)
                .NotEmpty()
                .WithMessage("Recommendation description is required.");

            RuleFor(x => x.Rationale)
                .NotEmpty()
                .WithMessage("Recommendation rationale is required.");

            RuleFor(x => x.EstimatedSavingsAmount)
                .GreaterThanOrEqualTo(0)
                .When(x => x.EstimatedSavingsAmount.HasValue)
                .WithMessage("Estimated savings amount must be greater than or equal to zero.");

            RuleFor(x => x.CurrencyCode)
                .NotEmpty()
                .WithMessage("Currency code is required.")
                .Length(3)
                .WithMessage("Currency code must contain exactly 3 characters.");

            RuleFor(x => x.Status)
                .IsInEnum()
                .WithMessage("Invalid recommendation status.");
        }
    }
}
