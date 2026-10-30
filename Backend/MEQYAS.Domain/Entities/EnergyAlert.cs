using MEQYAS.Domain.Entities.Analysis;
using MEQYAS.Domain.Enums;

namespace MEQYAS.Domain.Entities;

//ده الكلاس التنيهات 
/// <summary>
/// Represents an energy-related alert generated for a factory or a specific energy meter.
/// </summary>
public class EnergyAlert
{
    /// <summary>
    /// Gets or sets the unique identifier for the energy alert.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the unique identifier of the factory associated with this alert.
    /// </summary>
    public Guid? FactoryId { get; set; }
    /// <summary>
    /// Gets or sets the unique identifier of the specific energy meter associated with this alert, if applicable.
    /// </summary>
    public Guid? EnergyMeterId { get; set; }

    /// <summary>
    /// Gets or sets the type or category of the alert.
    /// </summary>
    public AlertType AlertType { get; set; }

    /// <summary>
    /// Gets or sets the severity level of the alert.
    /// </summary>
    public AlertSeverity Severity { get; set; }

    /// <summary>
    /// Gets or sets the title or short summary of the alert.
    /// </summary>
    public string Title { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the detailed description of the alert condition.
    /// </summary>
    public string Description { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the actual observed value that triggered the alert, if applicable.
    /// </summary>
    public decimal? ObservedValue { get; set; }

    /// <summary>
    /// Gets or sets the expected normal value against which the observed value was compared, if applicable.
    /// </summary>
    public decimal? ExpectedValue { get; set; }

    /// <summary>
    /// Gets or sets the date and time in UTC when the alert was detected.
    /// </summary>
    public DateTime DetectedAtUtc { get; set; }

    /// <summary>
    /// Gets or sets the current status of the alert (e.g., Active, Resolved, Acknowledged).
    /// </summary>
    public AlertStatus Status { get; set; }

    // Navigation Properties

    /// <summary>
    /// Gets or sets the factory that this alert belongs to.
    /// </summary>
    public Factory? Factory { get; set; }
    /// <summary>
    /// Gets or sets the specific energy meter associated with this alert, if any.
    /// </summary>
    public EnergyMeter? EnergyMeter { get; set; }

    /// <summary>
    /// Gets or sets the collection of recommendations associated with this alert.
    /// </summary>
    public ICollection<Recommendation> Recommendations { get; set; }
        = new List<Recommendation>();


    public Guid? AnalysisResultId { get; set; }
    public AnalysisResult? AnalysisResult { get; set; }
}