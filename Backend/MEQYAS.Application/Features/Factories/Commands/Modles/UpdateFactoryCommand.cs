using MediatR;
using MEQYAS.Application.Bases;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.Factories.Commands.Modles
{
    public class UpdateFactoryCommand:IRequest<Response<string>>
    {
        public Guid Id { set; get; }
        public string Name { get; set; } = string.Empty;


        public string Code { get; set; } = string.Empty;


        public string? Address { get; set; }
    }
}
