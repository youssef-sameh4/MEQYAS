using MEQYAS.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Application.Abstractions.Interfaces
{
    public interface IUnitOfWork : IDisposable
    {
        IGenericRepository<Factory> Factories { get; }

        IGenericRepository<EnergyMeter> EnergyMeters { get; }

        IGenericRepository<EnergyReading> EnergyReadings { get; }

        IGenericRepository<EnergyTariff> EnergyTariffs { get; }

        IGenericRepository<EnergyAlert> EnergyAlerts { get; }

        IGenericRepository<Recommendation> Recommendations { get; }

        IGenericRepository<SavingsSimulation> SavingsSimulations { get; }

        Task<int> SaveChangesAsync(
            CancellationToken cancellationToken = default);

    }
}
