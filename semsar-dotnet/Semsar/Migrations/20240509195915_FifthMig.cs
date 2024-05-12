using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Semsar.Migrations
{
    /// <inheritdoc />
    public partial class FifthMig : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Username",
                table: "HouseDetails");

            migrationBuilder.AddColumn<int>(
                name: "Area",
                table: "HouseDetails",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "DiningRooms",
                table: "HouseDetails",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<bool>(
                name: "IsForRent",
                table: "HouseDetails",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "IsForSale",
                table: "HouseDetails",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<int>(
                name: "Lavatory",
                table: "HouseDetails",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<double>(
                name: "Rent",
                table: "HouseDetails",
                type: "float",
                nullable: false,
                defaultValue: 0.0);

            migrationBuilder.AddColumn<int>(
                name: "Rooms",
                table: "HouseDetails",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "SleepingRooms",
                table: "HouseDetails",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Area",
                table: "HouseDetails");

            migrationBuilder.DropColumn(
                name: "DiningRooms",
                table: "HouseDetails");

            migrationBuilder.DropColumn(
                name: "IsForRent",
                table: "HouseDetails");

            migrationBuilder.DropColumn(
                name: "IsForSale",
                table: "HouseDetails");

            migrationBuilder.DropColumn(
                name: "Lavatory",
                table: "HouseDetails");

            migrationBuilder.DropColumn(
                name: "Rent",
                table: "HouseDetails");

            migrationBuilder.DropColumn(
                name: "Rooms",
                table: "HouseDetails");

            migrationBuilder.DropColumn(
                name: "SleepingRooms",
                table: "HouseDetails");

            migrationBuilder.AddColumn<string>(
                name: "Username",
                table: "HouseDetails",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }
    }
}
