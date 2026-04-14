# ✈️ Aviation Database Management System

## 📖 Description
A fully structured SQL Server database for an Airline Reservation System.
It manages airlines, airports, passengers, flights, reservations, and
payments — with real-world business logic implemented using advanced SQL features.

## 🚀 Features
- Full airline & airport data management
- Passenger registration and profile management
- Flight booking and cancellation system
- Payment tracking with multiple payment methods
- Automated seat availability updates on booking/cancellation
- Revenue and booking summary reports
- Booking audit log (tracks all INSERT, UPDATE, DELETE)
- Most popular routes and revenue-by-airline analysis

## 🛠️ Technologies Used
- Microsoft SQL Server (T-SQL)
- SQL Server Management Studio (SSMS)

## 🧠 Concepts Applied
- Database Design & Normalization
- Primary Keys, Foreign Keys & Constraints
- DDL — `CREATE`, `ALTER`, `DROP`
- DML — `INSERT`, `UPDATE`, `DELETE`
- `SELECT` with `WHERE`, `LIKE`, `IN`, `BETWEEN`, `ORDER BY`, `TOP`
- Aggregate Functions — `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`
- `GROUP BY` with `HAVING`
- Joins — `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, multi-table joins
- Views — `vw_FlightDetails`, `vw_PassengerBookings`, `vw_RevenueSummary`
- Scalar & Table-Valued Functions
- Stored Procedures — `sp_BookFlight`, `sp_CancelReservation`, `sp_GetPassengerReport`
- Triggers — Audit log on INSERT, UPDATE, DELETE
- Column Aliases & DISTINCT queries

## ▶️ How to Run
1. Open **SQL Server Management Studio (SSMS)**
2. Run the full `.sql` script
3. The database `AirlineSystem` will be created automatically
4. Execute any section individually to test queries

## 🗄️ Database Schema
| Table | Description |
|-------|-------------|
| Airlines | Airline companies |
| Airports | Airport details |
| Passengers | Passenger profiles |
| Flights | Flight schedules & pricing |
| Reservations | Booking records |
| Payments | Payment transactions |
| Booking_Audit_Log | Trigger-based audit trail |

## ✨ Future Improvements
- Connect to a frontend (C# / Web App)
- Add login & role-based access (Admin / Passenger)
- Integrate real-time seat map
