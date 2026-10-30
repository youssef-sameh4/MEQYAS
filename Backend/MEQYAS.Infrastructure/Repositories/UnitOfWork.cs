using MEQYAS.Application.Abstractions.Interfaces;
using MEQYAS.Domain.Entities;
using MEQYAS.Domain.Entities.Analysis;
using MEQYAS.Infrastructure.Persistence;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MEQYAS.Infrastructure.Repositories
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly AppDbContext _context;

        public IGenericRepository<Factory> Factories { get; }

        public IGenericRepository<EnergyMeter> EnergyMeters { get; }

        public IGenericRepository<EnergyReading> EnergyReadings { get; }

        public IGenericRepository<EnergyTariff> EnergyTariffs { get; }

        public IGenericRepository<EnergyAlert> EnergyAlerts { get; }

        public IGenericRepository<Recommendation> Recommendations { get; }

        public IGenericRepository<SavingsSimulation> SavingsSimulations { get; }
        public IGenericRepository<AnalysisRun> AnalysisRuns { get; }

        public IGenericRepository<AnalysisResult> AnalysisResults { get; }
        public UnitOfWork(AppDbContext context)
        {
            _context = context;

            Factories = new GenericRepository<Factory>(_context);
            EnergyMeters = new GenericRepository<EnergyMeter>(_context);
            EnergyReadings = new GenericRepository<EnergyReading>(_context);
            EnergyTariffs = new GenericRepository<EnergyTariff>(_context);
            EnergyAlerts = new GenericRepository<EnergyAlert>(_context);
            Recommendations = new GenericRepository<Recommendation>(_context);
            SavingsSimulations = new GenericRepository<SavingsSimulation>(_context);
            AnalysisRuns = new GenericRepository<AnalysisRun>(_context);

            AnalysisResults = new GenericRepository<AnalysisResult>(_context);
        }

        public Task<int> SaveChangesAsync(
            CancellationToken cancellationToken = default)
        {
            return _context.SaveChangesAsync(cancellationToken);
        }

        public void Dispose()
        {
            _context.Dispose();
        }

    }
}
