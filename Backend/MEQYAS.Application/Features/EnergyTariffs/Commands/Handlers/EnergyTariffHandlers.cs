using AutoMapper;
using FluentValidation;
using MediatR;
using MEQYAS.Application.Abstractions.Interfaces;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Bases.MEQYAS.Application.Bases;
using MEQYAS.Application.Features.EnergyTariffs.Commands.Models;
using MEQYAS.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyTariffs.Commands.Handlers
{
    public class EnergyTariffHandlers : ResponseHandler, IRequestHandler<CreateEnergyTariffCommand, Response<string>>,
        IRequestHandler<UpdateEnergyTariffCommand, Response<string>>

    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IMapper _mapper;
        private readonly IValidator<CreateEnergyTariffCommand> _createValidator;
        private readonly IValidator<UpdateEnergyTariffCommand> _updateValidator;

        public EnergyTariffHandlers(IUnitOfWork unitOfWork, IMapper mapper, IValidator<CreateEnergyTariffCommand> createValidator, IValidator<UpdateEnergyTariffCommand> updateValidator)
        {
            _unitOfWork = unitOfWork;
            _mapper = mapper;
            _createValidator = createValidator;
            _updateValidator = updateValidator;
        }

        public async Task<Response<string>> Handle(
            CreateEnergyTariffCommand request,
            CancellationToken cancellationToken)
        {
            // Validation
            var validationResult = await _createValidator.ValidateAsync(
                request, cancellationToken);

            if (!validationResult.IsValid)
            {
                var errors = string.Join(" | ",
                    validationResult.Errors.Select(x => x.ErrorMessage));

                return BadRequest<string>(errors);
            }
            var factoryExists = await _unitOfWork.Factories
                .GetTableNoTracking()
                .AnyAsync(x => x.Id == request.FactoryId, cancellationToken);

            if (!factoryExists)
                return NotFound<string>("Factory not found.");

            var energyTariff = _mapper.Map<EnergyTariff>(request);

            energyTariff.Id = Guid.NewGuid();
            energyTariff.CreatedAtUtc = DateTime.UtcNow;

            await _unitOfWork.EnergyTariffs.AddAsync(
                energyTariff, cancellationToken);

            await _unitOfWork.SaveChangesAsync();

            return Created("Energy tariff created successfully.");
        }

        public async Task<Response<string>> Handle(
            UpdateEnergyTariffCommand request,
            CancellationToken cancellationToken)
        {
            var validationResult = await _updateValidator.ValidateAsync(
           request, cancellationToken);

            if (!validationResult.IsValid)
            {
                var errors = string.Join(" | ",
                    validationResult.Errors.Select(x => x.ErrorMessage));

                return BadRequest<string>(errors);
            }
            var energyTariff = await _unitOfWork.EnergyTariffs
                .GetByIdAsync(request.Id, cancellationToken);

            if (energyTariff is null)
                return NotFound<string>("Energy tariff not found.");

            energyTariff.Name = request.Name;
            energyTariff.PricePerKwh = request.PricePerKwh;
            energyTariff.CurrencyCode = request.CurrencyCode;
            energyTariff.EffectiveFrom = request.EffectiveFrom;
            energyTariff.EffectiveTo = request.EffectiveTo;

            await _unitOfWork.SaveChangesAsync();

            return Success("Energy tariff updated successfully.");
        }
    }
}
