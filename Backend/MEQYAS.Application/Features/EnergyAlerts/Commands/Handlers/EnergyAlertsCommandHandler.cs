using AutoMapper;
using MediatR;
using MEQYAS.Application.Abstractions.Interfaces;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Bases.MEQYAS.Application.Bases;
using MEQYAS.Application.Features.EnergyAlerts.Commands.Models;
using MEQYAS.Domain.Entities;
using MEQYAS.Domain.Enums;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyAlerts.Commands.Handlers
{
    internal class EnergyAlertsCommandHandler : ResponseHandler,
        IRequestHandler<CreateEnergyAlertCommand, Response<string>>,
        IRequestHandler<UpdateEnergyAlertCommand, Response<string>>,
        IRequestHandler<DeleteEnergyAlertCommand, Response<string>>
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IMapper _mapper;

        public EnergyAlertsCommandHandler(
            IUnitOfWork unitOfWork,
            IMapper mapper)
        {
            _unitOfWork = unitOfWork;
            _mapper = mapper;
        }

        public async Task<Response<string>> Handle(
            CreateEnergyAlertCommand request,
            CancellationToken cancellationToken)
        {
            var factory = await _unitOfWork.Factories
                .GetTableNoTracking()
                .FirstOrDefaultAsync(
                    f => f.Id == request.FactoryId,
                    cancellationToken);

            if (factory is null)
                return NotFound<string>("Factory not found.");

            if (request.EnergyMeterId.HasValue)
            {
                var meter = await _unitOfWork.EnergyMeters
                    .GetTableNoTracking()
                    .FirstOrDefaultAsync(
                        m => m.Id == request.EnergyMeterId.Value,
                        cancellationToken);

                if (meter is null)
                    return NotFound<string>("Energy meter not found.");

                if (meter.FactoryId != request.FactoryId)
                    return BadRequest<string>(
                        "Energy meter does not belong to the specified factory.");
            }

            var alert = _mapper.Map<EnergyAlert>(request);

            alert.Id = Guid.NewGuid();
            alert.DetectedAtUtc = DateTime.UtcNow;
            alert.Status = AlertStatus.New;

            await _unitOfWork.EnergyAlerts.AddAsync(
                alert,
                cancellationToken);

            await _unitOfWork.SaveChangesAsync();

            return Created("Energy alert created successfully.");
        }

        public async Task<Response<string>> Handle(
            UpdateEnergyAlertCommand request,
            CancellationToken cancellationToken)
        {
            var alert = await _unitOfWork.EnergyAlerts
                .GetTableAsTracking()
                .FirstOrDefaultAsync(
                    a => a.Id == request.Id,
                    cancellationToken);

            if (alert is null)
                return NotFound<string>("Energy alert not found.");

            alert.Severity = request.Severity;
            alert.Title = request.Title;
            alert.Description = request.Description;
            alert.Status = request.Status;

            await _unitOfWork.SaveChangesAsync();

            return Success("Energy alert updated successfully.");
        }

        public async Task<Response<string>> Handle(
            DeleteEnergyAlertCommand request,
            CancellationToken cancellationToken)
        {
            var alert = await _unitOfWork.EnergyAlerts
                .GetTableAsTracking()
                .FirstOrDefaultAsync(
                    a => a.Id == request.Id,
                    cancellationToken);

            if (alert is null)
                return NotFound<string>("Energy alert not found.");

             _unitOfWork.EnergyAlerts.Delete(alert);

            await _unitOfWork.SaveChangesAsync();

            return Deleted<string>("Energy alert deleted successfully.");
        }
    }
}
