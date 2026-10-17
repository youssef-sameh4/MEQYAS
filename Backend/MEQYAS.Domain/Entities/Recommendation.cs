using MEQYAS.Domain.Enums;

//ده كلاس التوصه
namespace MEQYAS.Domain.Entities;

/// <summary>
/// Represents an energy optimization recommendation generated for a factory or triggered by an energy alert.
/// </summary>
public class Recommendation
{
    /// <summary>
    /// Gets or sets the unique identifier for the recommendation.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the unique identifier of the factory associated with this recommendation.
    /// </summary>
    public Guid FactoryId { get; set; }

    /// <summary>
    /// Gets or sets the unique identifier of the energy alert that triggered this recommendation, if applicable.
    /// </summary>
    public Guid? EnergyAlertId { get; set; }

    /// <summary>
    /// Gets or sets the title or short summary of the recommendation.
    /// </summary>
    public string Title { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the detailed description of the recommended action.
    /// </summary>
    public string Description { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the reasoning or technical rationale behind the recommendation.
    /// </summary>
    public string Rationale { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the estimated financial savings amount resulting from implementing this recommendation, if applicable.
    /// </summary>
    public decimal? EstimatedSavingsAmount { get; set; }

    /// <summary>
    /// Gets or sets the ISO currency code for the estimated savings amount (e.g., USD, EGP).
    /// </summary>
    public string CurrencyCode { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the current status of the recommendation (e.g., Pending, Implemented, Dismissed).
    /// </summary>
    public RecommendationStatus Status { get; set; }

    /// <summary>
    /// Gets or sets the date and time in UTC when the recommendation was created.
    /// </summary>
    public DateTime CreatedAtUtc { get; set; }

    /// <summary>
    /// Gets or sets the factory associated with this recommendation.
    /// </summary>
    public Factory Factory { get; set; } = null!;

    /// <summary>
    /// Gets or sets the specific energy alert associated with this recommendation, if any.
    /// </summary>
    public EnergyAlert? EnergyAlert { get; set; }

    /// <summary>
    /// Gets or sets the collection of savings simulations generated based on this recommendation.
    /// </summary>
    public ICollection<SavingsSimulation> SavingsSimulations { get; set; }
        = new List<SavingsSimulation>();
}