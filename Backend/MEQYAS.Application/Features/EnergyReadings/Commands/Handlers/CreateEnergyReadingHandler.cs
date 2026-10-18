using AutoMapper;
using FluentValidation;
using MediatR;
using MEQYAS.Application.Abstractions.Interfaces;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Bases.MEQYAS.Application.Bases;
using MEQYAS.Application.Features.EnergyReadings.Commands.Models;
using MEQYAS.Application.Features.EnergyReadings.Queries.DTOS;
using MEQYAS.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyReadings.Commands.Handlers
{
    public class CreateEnergyReadingHandler : ResponseHandler,IRequestHandler<CreateEnergyReadingCommand, Response<string>>
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IMapper _mapper;
        private readonly IValidator<CreateEnergyReadingCommand> _validator;
        public CreateEnergyReadingHandler(IUnitOfWork unitOfWork, IMapper mapper,  IValidator<CreateEnergyReadingCommand> validator)
        {
            _unitOfWork = unitOfWork;
            _mapper = mapper;
            _validator = validator;
        }

        public async Task<Response<string>> Handle(CreateEnergyReadingCommand request, CancellationToken cancellationToken)
        {
            var validationResult = await _validator.ValidateAsync(
        request,
        cancellationToken);

            if (!validationResult.IsValid)
            {
                var errors = string.Join(
                    ", ",
                    validationResult.Errors.Select(x => x.ErrorMessage));

                return BadRequest<string>(errors);
            }

            var energyMeter = await _unitOfWork.EnergyMeters
         .GetTableNoTracking()
         .FirstOrDefaultAsync(
             x => x.Id == request.EnergyMeterId,
             cancellationToken);

            if (energyMeter is null)
            {
                return NotFound<string>(
                    "Energy meter not found.");
            }

            if (!energyMeter.IsActive)
            {
                return BadRequest<string>(
                    "Cannot add a reading to an inactive energy meter.");
            }

            var readingExists = await _unitOfWork.EnergyReadings
                .GetTableNoTracking()
                .AnyAsync(
                    x => x.EnergyMeterId == request.EnergyMeterId
                         && x.RecordedAtUtc == request.RecordedAtUtc,
                    cancellationToken);

            if (readingExists)
            {
                return BadRequest<string>(
                    "A reading already exists for this meter at the specified time.");
            }
            var energyReading = _mapper.Map<EnergyReading>(request);
            energyReading.Id = Guid.NewGuid();
            energyReading.CreatedAtUtc = DateTime.UtcNow;

            await _unitOfWork.EnergyReadings.AddAsync(
                energyReading,
                cancellationToken);

            await _unitOfWork.SaveChangesAsync();


            return Created("energy Reading Created Successfully");
        }
    }
}
