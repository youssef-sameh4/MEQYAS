using AutoMapper;
using MediatR;
using MEQYAS.Application.Abstractions.Interfaces;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Bases.MEQYAS.Application.Bases;
using MEQYAS.Application.Features.EnergyReadings.Queries.DTOS;
using MEQYAS.Application.Features.EnergyReadings.Queries.Models;
using System;
using Microsoft.EntityFrameworkCore;

namespace MEQYAS.Application.Features.EnergyReadings.Queries.Handlers
{
    public class EnergyReadingHandlers : ResponseHandler,
         IRequestHandler<GetAllEnergyReadingsQuery, Response<List<EnergyReadingDto>>>,
         IRequestHandler<GetEnergyReadingByIdQuery, Response<EnergyReadingDto>>,
         IRequestHandler<GetEnergyReadingsByMeterIdQuery, Response<List<EnergyReadingDto>>>,
         IRequestHandler<GetEnergyReadingsByDateRangeQuery, Response<List<EnergyReadingDto>>>

    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IMapper _mapper;

        public EnergyReadingHandlers(IUnitOfWork unitOfWork, IMapper mapper)
        {
            _unitOfWork = unitOfWork;
            _mapper = mapper;
        }

        public async Task<Response<List<EnergyReadingDto>>> Handle(
            GetAllEnergyReadingsQuery request,
            CancellationToken cancellationToken)
        {
            var readings = await _unitOfWork.EnergyReadings
                .GetTableNoTracking()
                .OrderByDescending(x => x.RecordedAtUtc)
                .ToListAsync(cancellationToken);

            var mappedReadings = _mapper.Map<List<EnergyReadingDto>>(readings);

            return Success(mappedReadings);
        }

        public async Task<Response<EnergyReadingDto>> Handle(
            GetEnergyReadingByIdQuery request,
            CancellationToken cancellationToken)
        {
            var reading = await _unitOfWork.EnergyReadings
                .GetByIdAsync(request.Id, cancellationToken);

            if (reading == null)
            {
                return NotFound<EnergyReadingDto>();
            }

            var mappedReading = _mapper.Map<EnergyReadingDto>(reading);

            return Success(mappedReading);
        }

        public async Task<Response<List<EnergyReadingDto>>> Handle(
            GetEnergyReadingsByMeterIdQuery request,
            CancellationToken cancellationToken)
        {
            var meterExists = await _unitOfWork.EnergyMeters
                .GetTableNoTracking()
                .AnyAsync(
                    x => x.Id == request.EnergyMeterId,
                    cancellationToken);

            if (!meterExists)
            {
                return NotFound<List<EnergyReadingDto>>();
            }

            var readings = await _unitOfWork.EnergyReadings
                .GetTableNoTracking()
                .Where(x => x.EnergyMeterId == request.EnergyMeterId)
                .OrderByDescending(x => x.RecordedAtUtc)
                .ToListAsync(cancellationToken);

            var mappedReadings = _mapper.Map<List<EnergyReadingDto>>(readings);

            return Success(mappedReadings);
        }

        public async Task<Response<List<EnergyReadingDto>>> Handle(
            GetEnergyReadingsByDateRangeQuery request,
            CancellationToken cancellationToken)
        {
            if (request.FromUtc >= request.ToUtc)
            {
                return BadRequest<List<EnergyReadingDto>>(
                    "FromUtc must be earlier than ToUtc.");
            }

            var meterExists = await _unitOfWork.EnergyMeters
                .GetTableNoTracking()
                .AnyAsync(
                    x => x.Id == request.EnergyMeterId,
                    cancellationToken);

            if (!meterExists)
            {
                return NotFound<List<EnergyReadingDto>>();
            }

            var readings = await _unitOfWork.EnergyReadings
                .GetTableNoTracking()
                .Where(x =>
                    x.EnergyMeterId == request.EnergyMeterId &&
                    x.RecordedAtUtc >= request.FromUtc &&
                    x.RecordedAtUtc <= request.ToUtc)
                .OrderBy(x => x.RecordedAtUtc)
                .ToListAsync(cancellationToken);

            var mappedReadings = _mapper.Map<List<EnergyReadingDto>>(readings);

            return Success(mappedReadings);
        }
    }

}
