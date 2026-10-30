using AutoMapper;
using FluentValidation;
using MediatR;
using MEQYAS.Application.Abstractions.Interfaces;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Bases.MEQYAS.Application.Bases;
using MEQYAS.Application.Features.EnergyMeters.Commands.Models;
using MEQYAS.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyMeters.Commands.Handlers
{
    public class EnergyMeterHandlers : ResponseHandler,
    IRequestHandler<CreateEnergyMeterCommand, Response<string>>,
         IRequestHandler<UpdateEnergyMeterCommand, Response<string>>,
         IRequestHandler<DeactivateEnergyMeterCommand, Response<string>>

    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IMapper _mapper;
        private readonly IValidator<CreateEnergyMeterCommand> _validator;
        private readonly IValidator<UpdateEnergyMeterCommand> _updatevalidator;
        public EnergyMeterHandlers(IUnitOfWork unitOfWork, IMapper mapper, IValidator<CreateEnergyMeterCommand> validator, IValidator<UpdateEnergyMeterCommand> updatevalidator)
        {
            _unitOfWork = unitOfWork;
            _mapper = mapper;
            _validator = validator;
            _updatevalidator = updatevalidator;
        }

        public async Task<Response<string>> Handle(CreateEnergyMeterCommand request, CancellationToken cancellationToken)
        {
            await _validator.ValidateAndThrowAsync(request, cancellationToken);

            var factory = await _unitOfWork.Factories.GetByIdAsync(request.FactoryId);

            if (factory == null)
                return NotFound<string>();

            var duplicateCode = await _unitOfWork.EnergyMeters
                .GetTableNoTracking()
                .AnyAsync(
                    x => x.FactoryId == request.FactoryId && x.Code == request.Code,
                    cancellationToken);

            if (duplicateCode)
                return BadRequest<string>("Meter code already exists in this factory.");

            var energyMeter = _mapper.Map<EnergyMeter>(request);

            energyMeter.Id = Guid.NewGuid();
            energyMeter.IsActive = true;
            energyMeter.CreatedAtUtc = DateTime.UtcNow;

            await _unitOfWork.EnergyMeters.AddAsync(energyMeter);
            await _unitOfWork.SaveChangesAsync();

            return Created("Energy Meter Created Successfully");
        }

        public async Task<Response<string>> Handle(UpdateEnergyMeterCommand request, CancellationToken cancellationToken)
        {
            await _updatevalidator.ValidateAndThrowAsync(
           request,
           cancellationToken);

            var energyMeter = await _unitOfWork.EnergyMeters
                .GetByIdAsync(request.Id);

            if (energyMeter == null)
                return NotFound<string>();

            var duplicateCode = await _unitOfWork.EnergyMeters
                .GetTableNoTracking()
                .AnyAsync(
                    x => x.FactoryId == energyMeter.FactoryId
                      && x.Code == request.Code
                      && x.Id != request.Id,
                    cancellationToken);

            if (duplicateCode)
                return BadRequest<string>(
                    "Meter code already exists in this factory.");

            energyMeter.Name = request.Name;
            energyMeter.Code = request.Code;
            energyMeter.MeterType = request.MeterType;
            energyMeter.Unit = request.Unit;

            _unitOfWork.EnergyMeters.Update(energyMeter);

            await _unitOfWork.SaveChangesAsync();

            return Success("Energy Meter Updated Successfully");
        }

        public async Task<Response<string>> Handle(DeactivateEnergyMeterCommand request, CancellationToken cancellationToken)
        {
            var energyMeter = await _unitOfWork.EnergyMeters
           .GetByIdAsync(request.Id);

            if (energyMeter == null)
                return NotFound<string>();

            if (!energyMeter.IsActive)
                return BadRequest<string>("Energy meter is already inactive.");

            energyMeter.IsActive = false;

            _unitOfWork.EnergyMeters.Update(energyMeter);

            await _unitOfWork.SaveChangesAsync();

            return Success("Energy Meter Deactivated Successfully");
        }
    }
}
