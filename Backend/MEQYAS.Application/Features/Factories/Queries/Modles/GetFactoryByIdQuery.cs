using MediatR;
using MEQYAS.Application.Bases;
using MEQYAS.Application.Features.Factories.Queries.DTOS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.Factories.Queries.Modles
{
    public class GetFactoryByIdQuery:IRequest<Response<FactoryDto>>
    {
        public Guid Id { set; get; }

        public GetFactoryByIdQuery(Guid id)
        {
            Id = id;
        }
    }
}
