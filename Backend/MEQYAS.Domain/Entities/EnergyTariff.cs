namespace MEQYAS.Domain.Entities;

//ده كلاس التعريفه
//المصنع الواحد بيقي بيه امتر منى اعريفه 
/// <summary>
/// Represents an energy tariff structure associated with a factory.
/// </summary>
public class EnergyTariff
{
    /// <summary>
    /// Gets or sets the unique identifier for the energy tariff.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the unique identifier of the factory associated with this tariff.
    /// </summary>
    public Guid FactoryId { get; set; }

    /// <summary>
    /// Gets or sets the name or label of the tariff plan.
    /// </summary>
    public string Name { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the cost per kilowatt-hour (kWh).
    /// </summary>
    public decimal PricePerKwh { get; set; }

    /// <summary>
    /// Gets or sets the ISO currency code for the tariff pricing (e.g., USD, EGP).
    /// </summary>
    public string CurrencyCode { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the start date and time from which the tariff becomes effective.
    /// </summary>
    public DateTime EffectiveFrom { get; set; }

    /// <summary>
    /// Gets or sets the end date and time until which the tariff remains effective, if applicable.
    /// </summary>
    public DateTime? EffectiveTo { get; set; }

    /// <summary>
    /// Gets or sets the date and time in UTC when the tariff record was created.
    /// </summary>
    public DateTime CreatedAtUtc { get; set; }

    // Navigation Property

    /// <summary>
    /// Gets or sets the factory associated with this energy tariff.
    /// </summary>
    public Factory Factory { get; set; } = null!;
}