using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MEQYAS.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddPowerFactorAnalysisSupport : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "AnalysisType",
                table: "AnalysisRuns",
                type: "int",
                nullable: false,
                defaultValue: 1);

            migrationBuilder.AddColumn<int>(
                name: "LowPfRiskCount",
                table: "AnalysisRuns",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "RiskRatePct",
                table: "AnalysisRuns",
                type: "decimal(5,2)",
                precision: 5,
                scale: 2,
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "ActualPowerFactor",
                table: "AnalysisResults",
                type: "decimal(18,8)",
                precision: 18,
                scale: 8,
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "ComputedQPRatio",
                table: "AnalysisResults",
                type: "decimal(18,8)",
                precision: 18,
                scale: 8,
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsLowPfRisk",
                table: "AnalysisResults",
                type: "bit",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Prediction",
                table: "AnalysisResults",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "RiskProbability",
                table: "AnalysisResults",
                type: "decimal(10,8)",
                precision: 10,
                scale: 8,
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "ThresholdUsed",
                table: "AnalysisResults",
                type: "decimal(10,8)",
                precision: 10,
                scale: 8,
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "AnalysisType",
                table: "AnalysisRuns");

            migrationBuilder.DropColumn(
                name: "LowPfRiskCount",
                table: "AnalysisRuns");

            migrationBuilder.DropColumn(
                name: "RiskRatePct",
                table: "AnalysisRuns");

            migrationBuilder.DropColumn(
                name: "ActualPowerFactor",
                table: "AnalysisResults");

            migrationBuilder.DropColumn(
                name: "ComputedQPRatio",
                table: "AnalysisResults");

            migrationBuilder.DropColumn(
                name: "IsLowPfRisk",
                table: "AnalysisResults");

            migrationBuilder.DropColumn(
                name: "Prediction",
                table: "AnalysisResults");

            migrationBuilder.DropColumn(
                name: "RiskProbability",
                table: "AnalysisResults");

            migrationBuilder.DropColumn(
                name: "ThresholdUsed",
                table: "AnalysisResults");
        }
    }
}
