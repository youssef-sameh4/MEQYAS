using AutoMapper;
using MediatR;
using MEQYAS.Application.Abstractions.Interfaces;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Bases.MEQYAS.Application.Bases;
using MEQYAS.Application.Features.EnergyAlerts.Queries.DTOS;
using MEQYAS.Application.Features.EnergyAlerts.Queries.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyAlerts.Queries.Handlers
{
    public class EnergyAlertsQueryHandler : ResponseHandler,
        IRequestHandler<GetAllEnergyAlertsQuery, Response<List<EnergyAlertDto>>>,
        IRequestHandler<GetEnergyAlertByIdQuery, Response<EnergyAlertDto>>,
        IRequestHandler<GetEnergyAlertsByFactoryIdQuery, Response<List<EnergyAlertDto>>>
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IMapper _mapper;

        public EnergyAlertsQueryHandler(
            IUnitOfWork unitOfWork,
            IMapper mapper)
        {
            _unitOfWork = unitOfWork;
            _mapper = mapper;
        }

        public async Task<Response<List<EnergyAlertDto>>> Handle(
            GetAllEnergyAlertsQuery request,
            CancellationToken cancellationToken)
        {
            var alerts = await _unitOfWork.EnergyAlerts
                .GetTableNoTracking()
                .OrderByDescending(a => a.DetectedAtUtc)
                .ToListAsync(cancellationToken);

            var result = _mapper.Map<List<EnergyAlertDto>>(alerts);

            return Success(result);
        }

        public async Task<Response<EnergyAlertDto>> Handle(
            GetEnergyAlertByIdQuery request,
            CancellationToken cancellationToken)
        {
            var alert = await _unitOfWork.EnergyAlerts
                .GetTableNoTracking()
                .FirstOrDefaultAsync(
                    a => a.Id == request.Id,
                    cancellationToken);

            if (alert is null)
                return NotFound<EnergyAlertDto>("Energy alert not found.");

            var result = _mapper.Map<EnergyAlertDto>(alert);

            return Success(result);
        }

        public async Task<Response<List<EnergyAlertDto>>> Handle(
            GetEnergyAlertsByFactoryIdQuery request,
            CancellationToken cancellationToken)
        {
            var alerts = await _unitOfWork.EnergyAlerts
                .GetTableNoTracking()
                .Where(a => a.FactoryId == request.FactoryId)
                .OrderByDescending(a => a.DetectedAtUtc)
                .ToListAsync(cancellationToken);

            var result = _mapper.Map<List<EnergyAlertDto>>(alerts);

            return Success(result);
        }
    }
}
