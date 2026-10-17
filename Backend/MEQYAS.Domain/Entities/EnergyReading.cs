using MEQYAS.Domain.Enums;

namespace MEQYAS.Domain.Entities;

//ده كلاس القرات
/// <summary>
/// Represents a specific energy consumption reading captured by a smart energy meter.
/// </summary>
public class EnergyReading
{
    /// <summary>
    /// Gets or sets the unique identifier for the energy reading.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the unique identifier of the energy meter that recorded this reading.
    /// </summary>
    public Guid EnergyMeterId { get; set; }

    /// <summary>
    /// Gets or sets the date and time in UTC when the reading was recorded.
    /// </summary>
    public DateTime RecordedAtUtc { get; set; }

    /// <summary>
    /// Gets or sets the measured energy consumption value.
    /// </summary>
    public decimal Value { get; set; }

    /// <summary>
    /// Gets or sets the type or category of the energy reading (e.g., Actual, Estimated).
    /// </summary>
    public ReadingType ReadingType { get; set; }

    /// <summary>
    /// Gets or sets the unit of measurement for this reading (e.g., kWh).
    /// </summary>
    public string Unit { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the date and time in UTC when this record was created in the system.
    /// </summary>
    public DateTime CreatedAtUtc { get; set; }

    // Navigation Properties

    /// <summary>
    /// Gets or sets the energy meter that captured this reading.
    /// </summary>
    public EnergyMeter EnergyMeter { get; set; } = null!;
}