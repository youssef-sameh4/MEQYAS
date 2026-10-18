using MEQYAS.Application.Abstractions.Interfaces;
using MEQYAS.Infrastructure.Persistence;
using MEQYAS.Infrastructure.Repositories;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Infrastructure
{
    public static class InfrastructureDependencies
    {
        public static IServiceCollection AddInfrastructureServices(
        this IServiceCollection services
)
        {

            services.AddScoped<IUnitOfWork, UnitOfWork>();

            return services;
        }

    }
}
