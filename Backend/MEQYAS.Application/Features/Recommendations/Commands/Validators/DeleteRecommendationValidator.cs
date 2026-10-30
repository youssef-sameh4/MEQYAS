using FluentValidation;
using MEQYAS.Application.Features.Recommendations.Commands.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.Recommendations.Commands.Validators
{
    public class DeleteRecommendationValidator : AbstractValidator<DeleteRecommendationCommand>
    {
        public DeleteRecommendationValidator()
        {
            RuleFor(x => x.Id)
                .NotEmpty()
                .WithMessage("Recommendation ID is required.");
        }
    }
}
