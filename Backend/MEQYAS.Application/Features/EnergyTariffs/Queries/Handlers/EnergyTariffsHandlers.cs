using AutoMapper;
using MediatR;
using MEQYAS.Application.Abstractions.Interfaces;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Bases.MEQYAS.Application.Bases;
using MEQYAS.Application.Features.EnergyTariffs.Queries.DTOS;
using MEQYAS.Application.Features.EnergyTariffs.Queries.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.EnergyTariffs.Queries.Handlers
{
    public class EnergyTariffsHandlers : ResponseHandler,IRequestHandler<GetAllEnergyTariffsQuery, Response<List<EnergyTariffDto>>>,
        IRequestHandler<GetEnergyTariffByIdQuery, Response<EnergyTariffDto>>,
        IRequestHandler<GetEnergyTariffsByFactoryIdQuery, Response<List<EnergyTariffDto>>>
    {
        private readonly IMapper _mapper;
        private readonly IUnitOfWork _unitOfWork;

        public EnergyTariffsHandlers(IMapper mapper, IUnitOfWork unitOfWork)
        {
            _mapper = mapper;
            _unitOfWork = unitOfWork;
        }

        public async Task<Response<List<EnergyTariffDto>>> Handle(GetAllEnergyTariffsQuery request, CancellationToken cancellationToken)
        {
            var EnergyTariffs = await _unitOfWork.EnergyTariffs.GetTableNoTracking().ToListAsync();
            var result = _mapper.Map<List<EnergyTariffDto>>(EnergyTariffs);
            return Success(result);
        }
        public async Task<Response<EnergyTariffDto>> Handle(
           GetEnergyTariffByIdQuery request,
           CancellationToken cancellationToken)
        {
            var energyTariff = await _unitOfWork.EnergyTariffs
                .GetByIdAsync(request.Id, cancellationToken);

            if (energyTariff == null)
            {
                return NotFound<EnergyTariffDto>();
            }

            var result = _mapper.Map<EnergyTariffDto>(energyTariff);

            return Success(result);
        }

        public async Task<Response<List<EnergyTariffDto>>> Handle(
            GetEnergyTariffsByFactoryIdQuery request,
            CancellationToken cancellationToken)
        {
            var factoryExists = await _unitOfWork.Factories
                .GetTableNoTracking()
                .AnyAsync(
                    x => x.Id == request.FactoryId,
                    cancellationToken);

            if (!factoryExists)
            {
                return NotFound<List<EnergyTariffDto>>();
            }

            var energyTariffs = await _unitOfWork.EnergyTariffs
                .GetTableNoTracking()
                .Where(x => x.FactoryId == request.FactoryId)
                .OrderByDescending(x => x.EffectiveFrom)
                .ToListAsync(cancellationToken);

            var result = _mapper.Map<List<EnergyTariffDto>>(energyTariffs);

            return Success(result);
        }

}
}
