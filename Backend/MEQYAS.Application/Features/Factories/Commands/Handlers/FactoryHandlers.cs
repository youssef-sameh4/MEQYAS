using AutoMapper;
using FluentValidation;
using MediatR;
using MEQYAS.Application.Abstractions.Interfaces;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Bases.MEQYAS.Application.Bases;
using MEQYAS.Application.Features.Factories.Commands.Modles;
using MEQYAS.Application.Features.Factories.Queries.DTOS;
using MEQYAS.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace MEQYAS.Application.Features.Factories.Commands.Handlers
{
    public class FactoryHandlers : ResponseHandler, IRequestHandler<CreateFactoryCommand, Response<string>>,
        IRequestHandler<UpdateFactoryCommand,Response<string>>,
        IRequestHandler<DeactivateFactoryCommand, Response<string>>
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IMapper _mapper;
        private readonly IValidator<CreateFactoryCommand> _validator;
        private readonly IValidator<UpdateFactoryCommand> _updateValidator;
        public FactoryHandlers(IUnitOfWork unitOfWork, IMapper mapper, IValidator<CreateFactoryCommand> validator, IValidator<UpdateFactoryCommand> updateValidator)
        {
            _unitOfWork = unitOfWork;
            _mapper = mapper;
            _validator = validator;
            _updateValidator = updateValidator;
        }

        public async Task<Response<string>> Handle(CreateFactoryCommand request, CancellationToken cancellationToken)
        {
            await _validator.ValidateAndThrowAsync(request, cancellationToken);
            var factoryMap = _mapper.Map<Factory>(request);
            factoryMap.Id = Guid.NewGuid();
            factoryMap.IsActive = true;
            factoryMap.CreatedAtUtc = DateTime.UtcNow;
            await _unitOfWork.Factories.AddAsync(factoryMap);
            await _unitOfWork.SaveChangesAsync();
            return Created("Factory Created Successfully");
        }

        public async Task<Response<string>> Handle(UpdateFactoryCommand request, CancellationToken cancellationToken)
        {
            await _updateValidator.ValidateAndThrowAsync(request, cancellationToken);
            var factory = await _unitOfWork.Factories.GetByIdAsync(request.Id);
            if (factory == null) return NotFound<string>();
            var duplicateCode = await _unitOfWork.Factories.GetTableNoTracking().AnyAsync(f => f.Code == request.Code && f.Id != request.Id, cancellationToken);
            if (factory == null)
            {
                return NotFound<string>();
            }
            factory.Name = request.Name;
            factory.Code = request.Code;
            factory.Address = request.Address;
             _unitOfWork.Factories.Update(factory);
            await _unitOfWork.SaveChangesAsync();
            return Success("Factory Updated Successfuly");
        }

        public async Task<Response<string>> Handle(DeactivateFactoryCommand request, CancellationToken cancellationToken)
        {
            var factory = await _unitOfWork.Factories.GetByIdAsync(request.Id);
            if (factory == null)
            {
                return NotFound<string>();
            }
            factory.IsActive = false;
            await _unitOfWork.SaveChangesAsync();
            return Success(" Factory Deactivate Successfully");
        }
    }
}
