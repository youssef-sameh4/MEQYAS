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
    public class GetAllFactoriesQuery:IRequest<Response<List<FactoryDto>>>
    {

    }
}
