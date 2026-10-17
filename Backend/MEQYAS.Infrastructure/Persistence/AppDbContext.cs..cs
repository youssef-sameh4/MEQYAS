using MEQYAS.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace MEQYAS.Infrastructure.Persistence;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public DbSet<Factory> Factories => Set<Factory>();
    public DbSet<EnergyMeter> EnergyMeters => Set<EnergyMeter>();
    public DbSet<EnergyReading> EnergyReadings => Set<EnergyReading>();
    public DbSet<EnergyTariff> EnergyTariffs => Set<EnergyTariff>();
    public DbSet<EnergyAlert> EnergyAlerts => Set<EnergyAlert>();
    public DbSet<Recommendation> Recommendations => Set<Recommendation>();
    public DbSet<SavingsSimulation> SavingsSimulations => Set<SavingsSimulation>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Factory
        modelBuilder.Entity<Factory>()
            .HasIndex(f => f.Code)
            .IsUnique();

        // EnergyMeter
        modelBuilder.Entity<EnergyMeter>()
            .HasIndex(m => new { m.FactoryId, m.Code })
            .IsUnique();

        // EnergyReading
        modelBuilder.Entity<EnergyReading>()
            .HasIndex(r => new { r.EnergyMeterId, r.RecordedAtUtc })
            .IsUnique();

        // Decimal Precision
        modelBuilder.Entity<EnergyTariff>()
            .Property(t => t.PricePerKwh)
            .HasPrecision(18, 4);

        modelBuilder.Entity<EnergyAlert>()
            .Property(a => a.ObservedValue)
            .HasPrecision(18, 4);

        modelBuilder.Entity<EnergyAlert>()
            .Property(a => a.ExpectedValue)
            .HasPrecision(18, 4);

        modelBuilder.Entity<Recommendation>()
            .Property(r => r.EstimatedSavingsAmount)
            .HasPrecision(18, 2);

        modelBuilder.Entity<SavingsSimulation>()
            .Property(s => s.BaselineConsumptionKwh)
            .HasPrecision(18, 4);

        modelBuilder.Entity<SavingsSimulation>()
            .Property(s => s.ReductionPercentage)
            .HasPrecision(5, 2);

        modelBuilder.Entity<SavingsSimulation>()
            .Property(s => s.BaselineCost)
            .HasPrecision(18, 2);

        modelBuilder.Entity<SavingsSimulation>()
            .Property(s => s.ProjectedConsumptionKwh)
            .HasPrecision(18, 4);

        modelBuilder.Entity<SavingsSimulation>()
            .Property(s => s.ProjectedCost)
            .HasPrecision(18, 2);

        modelBuilder.Entity<SavingsSimulation>()
            .Property(s => s.EstimatedSavingsAmount)
            .HasPrecision(18, 2);
    }
}