using MediatR;
using MEQYAS.Application.Bases;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Features.Factories.Commands.Modles
{
    public class CreateFactoryCommand:IRequest<Response<string>>
    {
        public string Name { get; set; } = string.Empty;

        /// <summary>
        /// Gets or sets the unique code assigned to identify the factory.
        /// </summary>
        public string Code { get; set; } = string.Empty;

        /// <summary>
        /// Gets or sets the physical address of the factory, if available.
        /// </summary>
        public string? Address { get; set; }


    }
}
