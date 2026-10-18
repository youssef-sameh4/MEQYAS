using FluentValidation;
using MEQYAS.Application.Features.Factories.Commands.Modles;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.Factories.Commands.Validators
{
    public class CreateFactoryCommandValidator
 : AbstractValidator<CreateFactoryCommand>
    {
        public CreateFactoryCommandValidator()
        {
            RuleFor(x => x.Name)
            .NotEmpty()
            .WithMessage("Factory name is required.")
            .MaximumLength(200)
            .WithMessage("Factory name must not exceed 200 characters.");

            RuleFor(x => x.Code)
                .NotEmpty()
                .WithMessage("Factory code is required.")
                .MaximumLength(50)
                .WithMessage("Factory code must not exceed 50 characters.");

            RuleFor(x => x.Address)
                .MaximumLength(500)
                .WithMessage("Factory address must not exceed 500 characters.");
        }

    }
}
