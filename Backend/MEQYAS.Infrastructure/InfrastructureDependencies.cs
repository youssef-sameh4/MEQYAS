using MEQYAS.Application.Abstractions.Interfaces;
using MEQYAS.Application.Features.Analysis.Interfaces;
using MEQYAS.Application.Features.PowerFactor.Interfaces;
using MEQYAS.Infrastructure.Persistence;
using MEQYAS.Infrastructure.Repositories;
using MEQYAS.Infrastructure.Services.AI;
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
            this IServiceCollection services,
            IConfiguration configuration)
        {
            // Memory Cache
            services.AddMemoryCache();

            // Unit Of Work
            services.AddScoped<IUnitOfWork, UnitOfWork>();

            // Model 1 - Dataset Service
            services.AddHttpClient<IDemoDatasetService, DemoDatasetService>();

            // Model 1 - AI Analysis Service
            services.AddHttpClient<IAIEnergyAnalysisService, AIEnergyAnalysisService>(
                client =>
                {
                    var baseUrl = configuration["AISettings:BaseUrl"];

                    if (string.IsNullOrWhiteSpace(baseUrl))
                    {
                        throw new InvalidOperationException(
                            "AISettings:BaseUrl is not configured.");
                    }

                    client.BaseAddress = new Uri(baseUrl);
                });

            // Model 2 - Power Factor Dataset Service
            services.AddHttpClient<IPowerFactorDatasetService, PowerFactorDatasetService>();

            // Model 2 - Power Factor AI Service
            services.AddHttpClient<IPowerFactorAnalysisService, PowerFactorAnalysisService>(
                client =>
                {
                    var baseUrl = configuration[
                        "PowerFactorAISettings:BaseUrl"];

                    if (string.IsNullOrWhiteSpace(baseUrl))
                    {
                        throw new InvalidOperationException(
                            "PowerFactorAISettings:BaseUrl is not configured.");
                    }

                    client.BaseAddress = new Uri(baseUrl);
                });

            return services;
        }
    }
}