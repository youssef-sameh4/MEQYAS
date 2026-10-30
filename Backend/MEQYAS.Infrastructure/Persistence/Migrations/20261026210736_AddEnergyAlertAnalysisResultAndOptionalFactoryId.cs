using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MEQYAS.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddEnergyAlertAnalysisResultAndOptionalFactoryId : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_EnergyAlerts_Factories_FactoryId",
                table: "EnergyAlerts");

            migrationBuilder.AlterColumn<Guid>(
                name: "FactoryId",
                table: "EnergyAlerts",
                type: "uniqueidentifier",
                nullable: true,
                oldClrType: typeof(Guid),
                oldType: "uniqueidentifier");

            migrationBuilder.AddColumn<Guid>(
                name: "AnalysisResultId",
                table: "EnergyAlerts",
                type: "uniqueidentifier",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_EnergyAlerts_AnalysisResultId",
                table: "EnergyAlerts",
                column: "AnalysisResultId");

            migrationBuilder.AddForeignKey(
                name: "FK_EnergyAlerts_AnalysisResults_AnalysisResultId",
                table: "EnergyAlerts",
                column: "AnalysisResultId",
                principalTable: "AnalysisResults",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_EnergyAlerts_Factories_FactoryId",
                table: "EnergyAlerts",
                column: "FactoryId",
                principalTable: "Factories",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_EnergyAlerts_AnalysisResults_AnalysisResultId",
                table: "EnergyAlerts");

            migrationBuilder.DropForeignKey(
                name: "FK_EnergyAlerts_Factories_FactoryId",
                table: "EnergyAlerts");

            migrationBuilder.DropIndex(
                name: "IX_EnergyAlerts_AnalysisResultId",
                table: "EnergyAlerts");

            migrationBuilder.DropColumn(
                name: "AnalysisResultId",
                table: "EnergyAlerts");

            migrationBuilder.AlterColumn<Guid>(
                name: "FactoryId",
                table: "EnergyAlerts",
                type: "uniqueidentifier",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"),
                oldClrType: typeof(Guid),
                oldType: "uniqueidentifier",
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_EnergyAlerts_Factories_FactoryId",
                table: "EnergyAlerts",
                column: "FactoryId",
                principalTable: "Factories",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
