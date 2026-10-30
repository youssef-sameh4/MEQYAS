using MEQYAS.Domain.Entities;
using MEQYAS.Domain.Entities.Analysis;
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
        IGenericRepository<AnalysisRun> AnalysisRuns { get; }

        IGenericRepository<AnalysisResult> AnalysisResults { get; }
        Task<int> SaveChangesAsync(
            CancellationToken cancellationToken = default);

    }
}
