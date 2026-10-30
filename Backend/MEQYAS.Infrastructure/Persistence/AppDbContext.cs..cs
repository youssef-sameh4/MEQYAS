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
        modelBuilder.Entity<Factory>(entity =>
        {
            entity.HasIndex(f => f.Code).IsUnique();
            entity.Property(f => f.Name).HasMaxLength(200);
            entity.Property(f => f.Code).HasMaxLength(50);
        });

        // EnergyMeter
        modelBuilder.Entity<EnergyMeter>(entity =>
        {
            entity.HasIndex(m => new { m.FactoryId, m.Code }).IsUnique();
            entity.Property(m => m.Name).HasMaxLength(200);
            entity.Property(m => m.Code).HasMaxLength(50);
        });

        // EnergyReading
        modelBuilder.Entity<EnergyReading>(entity =>
        {
            entity.HasIndex(r => new { r.EnergyMeterId, r.RecordedAtUtc }).IsUnique();
            entity.Property(r => r.Value).HasPrecision(18, 4);
        });

        // EnergyTariff
        modelBuilder.Entity<EnergyTariff>(entity =>
        {
            entity.Property(t => t.PricePerKwh).HasPrecision(18, 4);
            entity.Property(t => t.CurrencyCode).HasMaxLength(3);
        });

        // EnergyAlert
        modelBuilder.Entity<EnergyAlert>(entity =>
        {
            entity.Property(a => a.ObservedValue).HasPrecision(18, 4);
            entity.Property(a => a.ExpectedValue).HasPrecision(18, 4);
        });

        // Recommendation
        modelBuilder.Entity<Recommendation>(entity =>
        {
            entity.Property(r => r.EstimatedSavingsAmount).HasPrecision(18, 2);
        });

        // SavingsSimulation
        modelBuilder.Entity<SavingsSimulation>(entity =>
        {
            entity.Property(s => s.BaselineConsumptionKwh).HasPrecision(18, 4);
            entity.Property(s => s.ReductionPercentage).HasPrecision(5, 2);
            entity.Property(s => s.BaselineCost).HasPrecision(18, 2);
            entity.Property(s => s.ProjectedConsumptionKwh).HasPrecision(18, 4);
            entity.Property(s => s.ProjectedCost).HasPrecision(18, 2);
            entity.Property(s => s.EstimatedSavingsAmount).HasPrecision(18, 2);
        });
    }
}