using MEQYAS.Domain.Enums;

namespace MEQYAS.Domain.Entities;

//ده كلاس المصانع 
/// <summary>
/// Represents an industrial facility or factory managed within the platform.
/// </summary>
public class Factory
{
    /// <summary>
    /// Gets or sets the unique identifier for the factory.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the official name of the factory.
    /// </summary>
    public string Name { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the unique code assigned to identify the factory.
    /// </summary>
    public string Code { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the physical address of the factory, if available.
    /// </summary>
    public string? Address { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether the factory is active in the system.
    /// </summary>
    public bool IsActive { get; set; }

    /// <summary>
    /// Gets or sets the date and time in UTC when the factory was created in the system.
    /// </summary>
    public DateTime CreatedAtUtc { get; set; }

    // Navigation Properties

    /// <summary>
    /// Gets or sets the collection of smart energy meters installed in this factory.
    /// </summary>
    public ICollection<EnergyMeter> EnergyMeters { get; set; }
        = new List<EnergyMeter>();

    /// <summary>
    /// Gets or sets the collection of energy tariff structures applied to this factory.
    /// </summary>
    public ICollection<EnergyTariff> EnergyTariffs { get; set; }
        = new List<EnergyTariff>();

    /// <summary>
    /// Gets or sets the collection of energy alerts generated for this factory.
    /// </summary>
    public ICollection<EnergyAlert> EnergyAlerts { get; set; }
        = new List<EnergyAlert>();

    /// <summary>
    /// Gets or sets the collection of energy savings recommendations created for this factory.
    /// </summary>
    public ICollection<Recommendation> Recommendations { get; set; }
        = new List<Recommendation>();

    /// <summary>
    /// Gets or sets the collection of savings simulations executed for this factory.
    /// </summary>
    public ICollection<SavingsSimulation> SavingsSimulations { get; set; }
        = new List<SavingsSimulation>();
}