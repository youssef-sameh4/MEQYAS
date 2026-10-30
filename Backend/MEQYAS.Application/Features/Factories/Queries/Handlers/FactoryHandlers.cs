using AutoMapper;
using MediatR;
using MEQYAS.Application.Abstractions.Interfaces;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Bases.MEQYAS.Application.Bases;
using MEQYAS.Application.Features.Factories.Queries.DTOS;
using MEQYAS.Application.Features.Factories.Queries.Modles;
using Microsoft.EntityFrameworkCore;
namespace MEQYAS.Application.Features.Factories.Queries.Handlers
{
    public class FactoryHandlers : ResponseHandler, IRequestHandler<GetAllFactoriesQuery, Response<List<FactoryDto>>>,
        IRequestHandler<GetFactoryByIdQuery,Response<FactoryDto>>
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IMapper _mapper;

        public FactoryHandlers(IUnitOfWork unitOfWork, IMapper mapper)
        {
            _unitOfWork = unitOfWork;
            _mapper = mapper;
        }

        public async Task<Response<List<FactoryDto>>> Handle(GetAllFactoriesQuery request, CancellationToken cancellationToken)
        {
            var factories = await _unitOfWork.Factories.GetTableNoTracking().ToListAsync(cancellationToken); ;
            var mapfactories = _mapper.Map<List<FactoryDto>>(factories);
            return Success(mapfactories);

        }

        public async Task<Response<FactoryDto>> Handle(GetFactoryByIdQuery request, CancellationToken cancellationToken)
        {
            var factory = await _unitOfWork.Factories.GetByIdAsync(request.Id);
            if (factory == null)
            {
                return NotFound<FactoryDto>();
            }
            var factoryMap = _mapper.Map<FactoryDto>(factory);
            return Success(factoryMap);
        }
    }
}
