namespace MEQYAS.Domain.Entities;

//ده كلاس المحاكاه
/// <summary>
/// Represents an energy savings scenario simulation created for a factory or based on a recommendation.
/// </summary>
public class SavingsSimulation
{
    /// <summary>
    /// Gets or sets the unique identifier for the savings simulation.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the unique identifier of the factory associated with this simulation.
    /// </summary>
    public Guid FactoryId { get; set; }

    /// <summary>
    /// Gets or sets the unique identifier of the recommendation on which this simulation is based, if applicable.
    /// </summary>
    public Guid? RecommendationId { get; set; }

    /// <summary>
    /// Gets or sets the name or description of the simulation scenario.
    /// </summary>
    public string Name { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the baseline energy consumption in kilowatt-hours (kWh) before applying efficiency measures.
    /// </summary>
    public decimal BaselineConsumptionKwh { get; set; }

    /// <summary>
    /// Gets or sets the targeted reduction percentage in energy consumption.
    /// </summary>
    public decimal ReductionPercentage { get; set; }

    /// <summary>
    /// Gets or sets the baseline financial cost based on current energy consumption.
    /// </summary>
    public decimal BaselineCost { get; set; }

    /// <summary>
    /// Gets or sets the projected energy consumption in kilowatt-hours (kWh) after simulated improvements.
    /// </summary>
    public decimal ProjectedConsumptionKwh { get; set; }

    /// <summary>
    /// Gets or sets the projected financial cost after simulated improvements.
    /// </summary>
    public decimal ProjectedCost { get; set; }

    /// <summary>
    /// Gets or sets the total estimated financial savings resulting from the simulation.
    /// </summary>
    public decimal EstimatedSavingsAmount { get; set; }

    /// <summary>
    /// Gets or sets the ISO currency code for financial calculations (e.g., USD, EGP).
    /// </summary>
    public string CurrencyCode { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the date and time in UTC when the simulation record was created.
    /// </summary>
    public DateTime CreatedAtUtc { get; set; }

    /// <summary>
    /// Gets or sets the factory associated with this savings simulation.
    /// </summary>
    public Factory Factory { get; set; } = null!;

    /// <summary>
    /// Gets or sets the specific recommendation linked to this simulation, if any.
    /// </summary>
    public Recommendation? Recommendation { get; set; }
}