using AutoMapper;
using MEQYAS.Application.Features.EnergyAlerts.Commands.Models;
using MEQYAS.Application.Features.EnergyAlerts.Queries.DTOS;
using MEQYAS.Application.Features.EnergyMeters.Commands.Models;
using MEQYAS.Application.Features.EnergyMeters.Queries.DTOS;
using MEQYAS.Application.Features.EnergyReadings.Commands.Models;
using MEQYAS.Application.Features.EnergyReadings.Queries.DTOS;
using MEQYAS.Application.Features.EnergyTariffs.Commands.Models;
using MEQYAS.Application.Features.EnergyTariffs.Queries.DTOS;
using MEQYAS.Application.Features.Factories.Commands.Modles;
using MEQYAS.Application.Features.Factories.Queries.DTOS;
using MEQYAS.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Mappings
{
    public class MappingProfile : Profile {
        public MappingProfile()
        {
            // Create Factory
            CreateMap<CreateFactoryCommand, Factory>();

            // Update Factory
            CreateMap<UpdateFactoryCommand, Factory>();

            // Factory to DTO
            CreateMap<Factory, FactoryDto>();
            // Energy Meter
            CreateMap<CreateEnergyMeterCommand, EnergyMeter>();
            CreateMap<EnergyMeter, EnergyMeterDto>();

            CreateMap<EnergyReading, EnergyReadingDto>();
            CreateMap<CreateEnergyReadingCommand, EnergyReading>();
            // Energy Tariff
            CreateMap<CreateEnergyTariffCommand, EnergyTariff>();
            CreateMap<UpdateEnergyTariffCommand, EnergyTariff>();
            CreateMap<EnergyTariff, EnergyTariffDto>();

            CreateMap<EnergyAlert, EnergyAlertDto>();
            CreateMap<CreateEnergyAlertCommand, EnergyAlert>();
        }
    }
}
