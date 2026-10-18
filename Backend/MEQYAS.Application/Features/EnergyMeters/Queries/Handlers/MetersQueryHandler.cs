using AutoMapper;
using MediatR;
using MEQYAS.Application.Abstractions.Interfaces;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Bases.MEQYAS.Application.Bases;
using MEQYAS.Application.Features.EnergyMeters.Queries.DTOS;
using MEQYAS.Application.Features.EnergyMeters.Queries.Models;
using Microsoft.EntityFrameworkCore;

namespace MEQYAS.Application.Features.EnergyMeters.Queries.Handlers
{
    public class MetersQueryHandler : ResponseHandler,
    IRequestHandler<GetAllEnergyMetersQuery, Response<List<EnergyMeterDto>>>,
    IRequestHandler<GetEnergyMeterByIdQuery, Response<EnergyMeterDto>>,
         IRequestHandler<
        GetEnergyMetersByFactoryIdQuery,
        Response<List<EnergyMeterDto>>>
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IMapper _mapper;

        public MetersQueryHandler(
            IUnitOfWork unitOfWork,
            IMapper mapper)
        {
            _unitOfWork = unitOfWork;
            _mapper = mapper;
        }

        public async Task<Response<List<EnergyMeterDto>>> Handle(
            GetAllEnergyMetersQuery request,
            CancellationToken cancellationToken)
        {
            var energyMeters = await _unitOfWork.EnergyMeters
                .GetTableNoTracking()
                .ToListAsync(cancellationToken);

            var mappedEnergyMeters = _mapper.Map<List<EnergyMeterDto>>(energyMeters);

            return Success(mappedEnergyMeters);
        }

        public async Task<Response<EnergyMeterDto>> Handle(GetEnergyMeterByIdQuery request, CancellationToken cancellationToken)
        {
            var energyMeter = await _unitOfWork.EnergyMeters
              .GetByIdAsync(request.Id);

            if (energyMeter == null)
                return NotFound<EnergyMeterDto>();

            var mappedEnergyMeter = _mapper.Map<EnergyMeterDto>(energyMeter);

            return Success(mappedEnergyMeter);
        }

        public async Task<Response<List<EnergyMeterDto>>> Handle(
       GetEnergyMetersByFactoryIdQuery request,
       CancellationToken cancellationToken)
        {
            var energyMeters = await _unitOfWork.EnergyMeters
                .GetTableNoTracking()
                .Where(x => x.FactoryId == request.FactoryId)
                .ToListAsync(cancellationToken);

            var mappedEnergyMeters =
                _mapper.Map<List<EnergyMeterDto>>(energyMeters);

            return Success(mappedEnergyMeters);
        }
    }
}
