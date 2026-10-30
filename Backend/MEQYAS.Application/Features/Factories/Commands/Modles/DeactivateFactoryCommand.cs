using MediatR;
using MEQYAS.Application.Bases;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.Factories.Commands.Modles
{
    public class DeactivateFactoryCommand:IRequest<Response<string>>
    {
        public Guid Id { set; get; }
    }
}
