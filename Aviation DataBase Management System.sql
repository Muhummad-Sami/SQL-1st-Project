-- =====================================================
-- AIRLINE RESERVATION SYSTEM 
-- Final Year Project
-- =====================================================

-- =====================================================
-- SECTION 1: DATABASE CREATION
-- =====================================================

-- Create Database
CREATE DATABASE AirlineSystem;
GO

-- Use the Database
USE AirlineSystem;
GO

-- =====================================================
-- SECTION 2: CREATE TABLES (WITH KEYS & CONSTRAINTS)
-- =====================================================

-- Table 1: Airlines (Parent Table)
CREATE TABLE Airlines (
    airline_id INT PRIMARY KEY IDENTITY(1,1),
    airline_name VARCHAR(100) NOT NULL,
    airline_code VARCHAR(10) NOT NULL UNIQUE,
    country VARCHAR(50),
    contact_number VARCHAR(20),
    email VARCHAR(100)
);

-- Table 2: Airports (Parent Table)
CREATE TABLE Airports (
    airport_id INT PRIMARY KEY IDENTITY(1,1),
    airport_code VARCHAR(10) NOT NULL UNIQUE,
    airport_name VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(50)
);

-- Table 3: Passengers (Parent Table)
CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    passport_number VARCHAR(20) UNIQUE,
    nationality VARCHAR(50)
);

-- Table 4: Flights (Child Table - References Airlines and Airports)
CREATE TABLE Flights (
    flight_id INT PRIMARY KEY IDENTITY(1,1),
    airline_id INT NOT NULL,
    flight_number VARCHAR(20) NOT NULL,
    departure_airport_id INT NOT NULL,
    arrival_airport_id INT NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    ticket_price DECIMAL(10, 2) NOT NULL,
    total_seats INT NOT NULL,
    available_seats INT NOT NULL,
    FOREIGN KEY (airline_id) REFERENCES Airlines(airline_id),
    FOREIGN KEY (departure_airport_id) REFERENCES Airports(airport_id),
    FOREIGN KEY (arrival_airport_id) REFERENCES Airports(airport_id)
);

-- Table 5: Reservations (Child Table - References Passengers and Flights)
CREATE TABLE Reservations (
    reservation_id INT PRIMARY KEY IDENTITY(1,1),
    passenger_id INT NOT NULL,
    flight_id INT NOT NULL,
    booking_date DATETIME DEFAULT GETDATE(),
    seat_number VARCHAR(10),
    status VARCHAR(20) DEFAULT 'Confirmed',
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);

-- Table 6: Payments
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    reservation_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATETIME DEFAULT GETDATE(),
    payment_method VARCHAR(20),
    status VARCHAR(20) DEFAULT 'Completed',
    FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id)
);

-- Table 7: Booking Audit Log (For Triggers)
CREATE TABLE Booking_Audit_Log (
    log_id INT PRIMARY KEY IDENTITY(1,1),
    reservation_id INT,
    passenger_id INT,
    flight_id INT,
    operation_type VARCHAR(10),
    operation_date DATETIME DEFAULT GETDATE(),
    changed_by VARCHAR(100) DEFAULT SYSTEM_USER
);

-- =====================================================
-- SECTION 3: INSERT SAMPLE DATA
-- =====================================================

-- Insert Airlines
INSERT INTO Airlines (airline_name, airline_code, country, contact_number, email) 
VALUES 
('Pakistan International Airlines', 'PIA', 'Pakistan', '+92-21-111-786-786', 'info@piac.com.pk'),
('Emirates Airlines', 'EK', 'UAE', '+971-4-214-4444', 'contact@emirates.com'),
('Qatar Airways', 'QR', 'Qatar', '+974-4023-0000', 'info@qatarairways.com'),
('Turkish Airlines', 'TK', 'Turkey', '+90-212-444-0849', 'info@turkishairlines.com'),
('Air Blue', 'PA', 'Pakistan', '+92-111-247-258', 'info@airblue.com');

-- Insert Airports
INSERT INTO Airports (airport_code, airport_name, city, country) 
VALUES 
('LHE', 'Allama Iqbal International Airport', 'Lahore', 'Pakistan'),
('KHI', 'Jinnah International Airport', 'Karachi', 'Pakistan'),
('ISB', 'Islamabad International Airport', 'Islamabad', 'Pakistan'),
('DXB', 'Dubai International Airport', 'Dubai', 'UAE'),
('DOH', 'Hamad International Airport', 'Doha', 'Qatar'),
('IST', 'Istanbul Airport', 'Istanbul', 'Turkey'),
('LHR', 'London Heathrow Airport', 'London', 'UK'),
('JFK', 'John F Kennedy International', 'New York', 'USA');

-- Insert Passengers
INSERT INTO Passengers (first_name, last_name, email, phone, passport_number, nationality) 
VALUES 
('Ahmed', 'Khan', 'ahmed.khan@email.com', '+92-300-1234567', 'PK1234567', 'Pakistani'),
('Fatima', 'Ali', 'fatima.ali@email.com', '+92-321-9876543', 'PK9876543', 'Pakistani'),
('John', 'Smith', 'john.smith@email.com', '+1-555-0123', 'US7654321', 'American'),
('Sarah', 'Ahmed', 'sarah.ahmed@email.com', '+92-333-5555555', 'PK5555555', 'Pakistani'),
('Mohammed', 'Hassan', 'mohammed.hassan@email.com', '+971-50-1234567', 'AE1231231', 'Emirati'),
('Ayesha', 'Malik', 'ayesha.malik@email.com', '+92-301-2223334', 'PK2223334', 'Pakistani'),
('Omar', 'Sheikh', 'omar.sheikh@email.com', '+92-345-6667778', 'PK6667778', 'Pakistani'),
('Zainab', 'Raza', 'zainab.raza@email.com', '+92-333-8889990', 'PK8889990', 'Pakistani');

-- Insert Flights
INSERT INTO Flights (airline_id, flight_number, departure_airport_id, arrival_airport_id, departure_time, arrival_time, ticket_price, total_seats, available_seats) 
VALUES 
(1, 'PK-701', 1, 2, '2025-11-01 08:00:00', '2025-11-01 10:30:00', 15000.00, 350, 345),
(2, 'EK-623', 4, 1, '2025-11-02 14:00:00', '2025-11-02 18:30:00', 35000.00, 489, 480),
(3, 'QR-629', 5, 3, '2025-11-03 09:30:00', '2025-11-03 13:00:00', 28000.00, 311, 305),
(4, 'TK-714', 6, 1, '2025-11-04 23:00:00', '2025-11-05 06:30:00', 42000.00, 326, 320),
(5, 'PA-402', 1, 3, '2025-11-05 07:00:00', '2025-11-05 08:15:00', 8000.00, 180, 175),
(1, 'PK-308', 1, 4, '2025-11-06 15:30:00', '2025-11-06 19:00:00', 32000.00, 350, 340),
(2, 'EK-701', 4, 7, '2025-11-07 02:00:00', '2025-11-07 07:30:00', 125000.00, 489, 480),
(3, 'QR-155', 5, 8, '2025-11-08 10:00:00', '2025-11-08 18:45:00', 155000.00, 311, 300);

-- Insert Reservations
INSERT INTO Reservations (passenger_id, flight_id, seat_number, status) 
VALUES 
(1, 1, '12A', 'Confirmed'),
(2, 2, '5B', 'Confirmed'),
(3, 4, '1A', 'Confirmed'),
(4, 5, '15C', 'Confirmed'),
(5, 3, '8D', 'Confirmed'),
(6, 1, '14B', 'Confirmed'),
(7, 6, '20F', 'Pending'),
(8, 7, '3C', 'Confirmed'),
(1, 6, '18A', 'Confirmed'),
(2, 3, '10C', 'Confirmed');

-- Insert Payments
INSERT INTO Payments (reservation_id, amount, payment_method, status) 
VALUES 
(1, 15000.00, 'Credit Card', 'Completed'),
(2, 35000.00, 'Debit Card', 'Completed'),
(3, 42000.00, 'Bank Transfer', 'Completed'),
(4, 8000.00, 'Cash', 'Completed'),
(5, 28000.00, 'Credit Card', 'Completed');

-- =====================================================
-- SECTION 4: BASIC SELECT QUERIES
-- =====================================================

-- 4.1 SELECT ALL (*)
SELECT * FROM Airlines;
SELECT * FROM Airports;
SELECT * FROM Passengers;
SELECT * FROM Flights;
SELECT * FROM Reservations;
SELECT * FROM Payments;
SELECT * FROM Booking_Audit_Log;

-- 4.2 SELECT SPECIFIC COLUMNS
SELECT airline_name, airline_code FROM Airlines;
SELECT airport_name, city FROM Airports;
SELECT first_name, last_name, email FROM Passengers;
SELECT flight_number, ticket_price FROM Flights;
SELECT reservation_id, seat_number, status FROM Reservations;

-- 4.3 SELECT WITH AS (Column Aliases)
SELECT 
    first_name + ' ' + last_name AS full_name,
    email AS contact_email,
    phone AS phone_number
FROM Passengers;

SELECT 
    flight_number AS flight,
    ticket_price AS price,
    available_seats AS seats
FROM Flights;

-- 4.4 SELECT DISTINCT
SELECT DISTINCT country FROM Airlines;
SELECT DISTINCT nationality FROM Passengers;
SELECT DISTINCT status FROM Reservations;

-- =====================================================
-- SECTION 5: SELECT WITH WHERE CLAUSE
-- =====================================================

SELECT * FROM Airlines WHERE country = 'Pakistan';
SELECT * FROM Airports WHERE country = 'Pakistan';
SELECT * FROM Passengers WHERE nationality = 'Pakistani';
SELECT * FROM Flights WHERE ticket_price < 50000;
SELECT * FROM Reservations WHERE status = 'Confirmed';
SELECT * FROM Flights WHERE available_seats > 300;
SELECT * FROM Passengers WHERE email = 'ahmed.khan@email.com';
SELECT * FROM Flights WHERE departure_airport_id = 1;
SELECT * FROM Flights WHERE ticket_price > 30000 AND available_seats > 300;

-- =====================================================
-- SECTION 6: SELECT WITH PATTERN MATCHING (LIKE)
-- =====================================================

SELECT * FROM Passengers WHERE email LIKE '%@email.com';
SELECT * FROM Passengers WHERE first_name LIKE 'A%';
SELECT * FROM Flights WHERE flight_number LIKE 'PK%';

-- =====================================================
-- SECTION 7: SELECT WITH IN OPERATOR
-- =====================================================

SELECT * FROM Airports WHERE country IN ('Pakistan', 'UAE', 'Qatar');
SELECT * FROM Passengers WHERE nationality IN ('Pakistani', 'American');
SELECT * FROM Airlines WHERE airline_code IN ('PIA', 'EK', 'QR');

-- =====================================================
-- SECTION 8: SELECT WITH BETWEEN
-- =====================================================

SELECT * FROM Flights WHERE ticket_price BETWEEN 10000 AND 50000;
SELECT * FROM Reservations WHERE reservation_id BETWEEN 1 AND 5;

-- =====================================================
-- SECTION 9: SELECT WITH ORDER BY
-- =====================================================

SELECT * FROM Passengers ORDER BY last_name;
SELECT * FROM Flights ORDER BY ticket_price ASC;
SELECT * FROM Flights ORDER BY ticket_price DESC;
SELECT * FROM Airlines ORDER BY airline_name;

-- =====================================================
-- SECTION 10: SELECT WITH TOP
-- =====================================================

SELECT TOP 5 * FROM Flights ORDER BY ticket_price ASC;
SELECT TOP 3 * FROM Flights ORDER BY ticket_price DESC;
SELECT TOP 5 * FROM Passengers;

-- =====================================================
-- SECTION 11: AGGREGATE FUNCTIONS
-- =====================================================

SELECT COUNT(*) AS total_airlines FROM Airlines;
SELECT COUNT(*) AS total_passengers FROM Passengers;
SELECT COUNT(*) AS total_flights FROM Flights;
SELECT SUM(ticket_price) AS total_revenue FROM Flights;
SELECT AVG(ticket_price) AS average_price FROM Flights;
SELECT MIN(ticket_price) AS cheapest_flight FROM Flights;
SELECT MAX(ticket_price) AS most_expensive_flight FROM Flights;

SELECT 
    COUNT(*) AS total_flights,
    AVG(ticket_price) AS avg_price,
    MIN(ticket_price) AS min_price,
    MAX(ticket_price) AS max_price
FROM Flights;

-- =====================================================
-- SECTION 12: GROUP BY
-- =====================================================

SELECT country, COUNT(*) AS airport_count FROM Airports GROUP BY country;
SELECT airline_id, COUNT(*) AS flight_count FROM Flights GROUP BY airline_id;
SELECT nationality, COUNT(*) AS passenger_count FROM Passengers GROUP BY nationality;
SELECT status, COUNT(*) AS count FROM Reservations GROUP BY status;

SELECT 
    airline_id, 
    COUNT(*) AS total_flights,
    AVG(ticket_price) AS avg_price
FROM Flights GROUP BY airline_id;

-- =====================================================
-- SECTION 13: GROUP BY WITH HAVING
-- =====================================================

SELECT passenger_id, COUNT(*) AS booking_count 
FROM Reservations 
GROUP BY passenger_id 
HAVING COUNT(*) > 1;

SELECT airline_id, COUNT(*) AS flight_count 
FROM Flights 
GROUP BY airline_id 
HAVING COUNT(*) > 2;

SELECT nationality , COUNT(*) AS Total_Members
FROM Passengers
GROUP BY nationality
HAVING COUNT(*) >= 1;

SELECT status , COUNT(*) AS Visa_Status
FROM Reservations
GROUP BY status
HAVING COUNT(*) >= 1;

SELECT payment_method,
       COUNT(*) AS payment_count,
       SUM(amount) AS total_amount,
       AVG(amount) AS avg_amount,
       MIN(amount) AS min_amount,
       MAX(amount) AS max_amount
FROM Payments
GROUP BY payment_method
HAVING SUM(amount) > 20000;

-- =====================================================
-- SECTION 14: JOINS
-- =====================================================

-- INNER JOIN
SELECT 
    Flights.flight_number,
    Airlines.airline_name,
    Flights.ticket_price
FROM Flights
INNER JOIN Airlines ON Flights.airline_id = Airlines.airline_id;

-- MULTIPLE TABLE JOIN
SELECT 
    Passengers.first_name,
    Passengers.last_name,
    Flights.flight_number,
    Reservations.seat_number
FROM Reservations
INNER JOIN Passengers ON Reservations.passenger_id = Passengers.passenger_id
INNER JOIN Flights ON Reservations.flight_id = Flights.flight_id;

-- COMPLEX JOIN WITH 4 TABLES
SELECT 
    Passengers.first_name + ' ' + Passengers.last_name AS passenger_name,
    Flights.flight_number,
    Airlines.airline_name,
    Dep.city AS departure_city,
    Arr.city AS arrival_city,
    Reservations.seat_number,
    Reservations.booking_date
FROM Reservations
INNER JOIN Passengers ON Reservations.passenger_id = Passengers.passenger_id
INNER JOIN Flights ON Reservations.flight_id = Flights.flight_id
INNER JOIN Airlines ON Flights.airline_id = Airlines.airline_id
INNER JOIN Airports AS Dep ON Flights.departure_airport_id = Dep.airport_id
INNER JOIN Airports AS Arr ON Flights.arrival_airport_id = Arr.airport_id;

-- LEFT JOIN
SELECT 
    Passengers.first_name,
    Passengers.last_name,
    Reservations.reservation_id
FROM Passengers
LEFT JOIN Reservations ON Passengers.passenger_id = Reservations.passenger_id;

-- RIGHT JOIN
SELECT 
    Flights.flight_number,
    Reservations.reservation_id
FROM Reservations
RIGHT JOIN Flights ON Reservations.flight_id = Flights.flight_id;

-- =====================================================
-- SECTION 15: VIEWS
-- =====================================================

-- VIEW 1: Flight Details
CREATE VIEW vw_FlightDetails AS
SELECT 
    f.flight_id,
    f.flight_number,
    a.airline_name,
    dep.city AS departure_city,
    arr.city AS arrival_city,
    f.departure_time,
    f.arrival_time,
    f.ticket_price,
    f.available_seats
FROM Flights f
INNER JOIN Airlines a ON f.airline_id = a.airline_id
INNER JOIN Airports dep ON f.departure_airport_id = dep.airport_id
INNER JOIN Airports arr ON f.arrival_airport_id = arr.airport_id;

-- VIEW 2: Passenger Booking History
CREATE VIEW vw_PassengerBookings AS
SELECT 
    p.passenger_id,
    p.first_name + ' ' + p.last_name AS passenger_name,
    p.email,
    f.flight_number,
    a.airline_name,
    r.booking_date,
    r.seat_number,
    r.status
FROM Reservations r
INNER JOIN Passengers p ON r.passenger_id = p.passenger_id
INNER JOIN Flights f ON r.flight_id = f.flight_id
INNER JOIN Airlines a ON f.airline_id = a.airline_id;

-- VIEW 3: Revenue Summary
CREATE VIEW vw_RevenueSummary AS
SELECT 
    a.airline_name,
    COUNT(r.reservation_id) AS total_bookings,
    SUM(f.ticket_price) AS total_revenue,
    AVG(f.ticket_price) AS average_ticket_price
FROM Airlines a
INNER JOIN Flights f ON a.airline_id = f.airline_id
INNER JOIN Reservations r ON f.flight_id = r.flight_id
WHERE r.status = 'Confirmed'
GROUP BY a.airline_name;

-- Using Views
SELECT * FROM vw_FlightDetails;
SELECT * FROM vw_PassengerBookings WHERE passenger_name LIKE 'Ahmed%';
SELECT * FROM vw_RevenueSummary ORDER BY total_revenue DESC;

-- =====================================================
-- SECTION 16: FUNCTIONS
-- =====================================================

-- SCALAR FUNCTION: Calculate Discount
CREATE FUNCTION fn_CalculateDiscount(@passenger_id INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @discount_rate DECIMAL(5,2);
    DECLARE @booking_count INT;
    
    SELECT @booking_count = COUNT(*) 
    FROM Reservations 
    WHERE passenger_id = @passenger_id AND status = 'Confirmed';
    
    IF @booking_count >= 5
        SET @discount_rate = 0.15;
    ELSE IF @booking_count >= 3
        SET @discount_rate = 0.10;
    ELSE IF @booking_count >= 1
        SET @discount_rate = 0.05;
    ELSE
        SET @discount_rate = 0.00;
    
    RETURN @discount_rate;
END;
GO

-- TABLE-VALUED FUNCTION: Get Flights by Route
CREATE FUNCTION fn_GetFlightsByRoute(
    @departure_city VARCHAR(100),
    @arrival_city VARCHAR(100)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        f.flight_number,
        a.airline_name,
        f.departure_time,
        f.arrival_time,
        f.ticket_price,
        f.available_seats
    FROM Flights f
    INNER JOIN Airlines a ON f.airline_id = a.airline_id
    INNER JOIN Airports dep ON f.departure_airport_id = dep.airport_id
    INNER JOIN Airports arr ON f.arrival_airport_id = arr.airport_id
    WHERE dep.city = @departure_city AND arr.city = @arrival_city
);

-- Using Functions
SELECT 
    passenger_id,
    first_name + ' ' + last_name AS passenger_name,
    dbo.fn_CalculateDiscount(passenger_id) * 100 AS discount_percentage
FROM Passengers;

SELECT * FROM dbo.fn_GetFlightsByRoute('Lahore', 'Karachi');

-- =====================================================
-- SECTION 17: STORED PROCEDURES
-- =====================================================

-- PROCEDURE: Book Flight
CREATE PROCEDURE sp_BookFlight
    @passenger_id INT,
    @flight_id INT,
    @seat_number VARCHAR(10)
AS
BEGIN
    DECLARE @available_seats INT;

    SELECT @available_seats = available_seats
    FROM Flights
    WHERE flight_id = @flight_id;

    IF @available_seats > 0
    BEGIN
        INSERT INTO Reservations (passenger_id, flight_id, seat_number, status)
        VALUES (@passenger_id, @flight_id, @seat_number, 'Confirmed');

        UPDATE Flights
        SET available_seats = available_seats - 1
        WHERE flight_id = @flight_id;

        PRINT 'Booking successful!';
    END
    ELSE
    BEGIN
        PRINT 'No seats available!';
    END
END;
GO


-- PROCEDURE 2: Cancel Reservation

CREATE PROCEDURE sp_CancelReservation
    @reservation_id INT
AS
BEGIN
    DECLARE @flight_id INT;

    SELECT @flight_id = flight_id
    FROM Reservations
    WHERE reservation_id = @reservation_id;

    UPDATE Reservations
    SET status = 'Cancelled'
    WHERE reservation_id = @reservation_id;

    UPDATE Flights
    SET available_seats = available_seats + 1
    WHERE flight_id = @flight_id;

    PRINT 'Reservation cancelled successfully!';
END;
GO

-- PROCEDURE 3: Get Passenger Report
CREATE PROCEDURE sp_GetPassengerReport
    @passenger_id INT
AS
BEGIN
    SELECT 
        p.first_name + ' ' + p.last_name AS passenger_name,
        p.email,
        p.nationality,
        COUNT(r.reservation_id) AS total_bookings,
        SUM(f.ticket_price) AS total_spent
    FROM Passengers p
    LEFT JOIN Reservations r ON p.passenger_id = r.passenger_id
    LEFT JOIN Flights f ON r.flight_id = f.flight_id
    WHERE p.passenger_id = @passenger_id
    GROUP BY p.passenger_id, p.first_name, p.last_name, p.email, p.nationality;
END;
GO
select *from Reservations
-- Using Stored Procedures
EXEC sp_BookFlight @passenger_id = 5, @flight_id = 3, @seat_number = '38C';
EXEC sp_CancelReservation @reservation_id = 11;
EXEC sp_GetPassengerReport @passenger_id = 2;

-- =====================================================
-- SECTION 18: TRIGGERS
-- =====================================================

-- TRIGGER 1: Audit Reservation Insert
CREATE TRIGGER trg_Reservation_Insert
ON Reservations
AFTER INSERT
AS
BEGIN
    INSERT INTO Booking_Audit_Log (reservation_id, passenger_id, flight_id, operation_type)
    SELECT reservation_id, passenger_id, flight_id, 'INSERT'
    FROM inserted;
END;
GO

-- TRIGGER 2: Audit Reservation Update
CREATE TRIGGER trg_Reservation_Update
ON Reservations
AFTER UPDATE
AS
BEGIN
    INSERT INTO Booking_Audit_Log (reservation_id, passenger_id, flight_id, operation_type)
    SELECT reservation_id, passenger_id, flight_id, 'UPDATE'
    FROM inserted;
END;
GO

-- TRIGGER 3: Audit Reservation Delete
CREATE TRIGGER trg_Reservation_Delete
ON Reservations
AFTER DELETE
AS
BEGIN
    INSERT INTO Booking_Audit_Log (reservation_id, passenger_id, flight_id, operation_type)
    SELECT reservation_id, passenger_id, flight_id, 'DELETE'
    FROM deleted;
END;
GO

-- Testing Triggers
INSERT INTO Reservations (passenger_id, flight_id, seat_number, status)
VALUES (5, 5, '31A', 'Confirmed');

UPDATE Reservations
SET status = 'Cancelled'
WHERE reservation_id = 1;

DELETE FROM Reservations WHERE reservation_id = 11;

SELECT * FROM Booking_Audit_Log;
SELECT * FROM Reservations;
-- =====================================================
-- SECTION 19: PRACTICAL BUSINESS QUERIES
-- =====================================================

-- Available Flights
SELECT 
    flight_number,
    departure_time,
    ticket_price,
    available_seats
FROM Flights
WHERE available_seats > 0
ORDER BY ticket_price;

-- Search Flights Between Cities
SELECT 
    f.flight_number,
    a.airline_name,
    dep.city AS from_city,
    arr.city AS to_city,
    f.ticket_price
FROM Flights f
INNER JOIN Airlines a ON f.airline_id = a.airline_id
INNER JOIN Airports dep ON f.departure_airport_id = dep.airport_id
INNER JOIN Airports arr ON f.arrival_airport_id = arr.airport_id
WHERE dep.city = 'Lahore' AND arr.city = 'Karachi';

-- Revenue by Airline
SELECT 
    a.airline_name,
    SUM(f.ticket_price) AS total_revenue
FROM Airlines a
INNER JOIN Flights f ON a.airline_id = f.airline_id
INNER JOIN Reservations r ON f.flight_id = r.flight_id
WHERE r.status = 'Confirmed'
GROUP BY a.airline_name;

-- Most Popular Routes
SELECT TOP 5
    dep.city AS from_city,
    arr.city AS to_city,
    COUNT(r.reservation_id) AS booking_count
FROM Flights f
INNER JOIN Airports dep ON f.departure_airport_id = dep.airport_id
INNER JOIN Airports arr ON f.arrival_airport_id = arr.airport_id
INNER JOIN Reservations r ON f.flight_id = r.flight_id
GROUP BY dep.city, arr.city
ORDER BY booking_count DESC;

-- =====================================================
-- SECTION 20: UPDATE & DELETE OPERATIONS
-- =====================================================

-- UPDATE Queries
UPDATE Passengers 
SET phone = '+92-300-9999999' 
WHERE passenger_id = 1;

UPDATE Flights 
SET available_seats = available_seats - 1 
WHERE flight_id = 1;

UPDATE Reservations 
SET status = 'Confirmed' 
WHERE status = 'Pending';

-- DELETE Queries
DELETE FROM Reservations WHERE reservation_id = 7;
DELETE FROM Reservations WHERE status = 'Cancelled';

-- =====================================================
-- SECTION 21: ALTER TABLE OPERATIONS
-- =====================================================

ALTER TABLE Passengers ADD date_of_birth DATE;
ALTER TABLE Flights ADD flight_status VARCHAR(20) DEFAULT 'Scheduled';
ALTER TABLE Airlines ALTER COLUMN contact_number VARCHAR(30);
ALTER TABLE Passengers DROP COLUMN date_of_birth;

-- =====================================================
-- SECTION 22: DATABASE SUMMARY & VERIFICATION
-- =====================================================

-- Database Summary
SELECT 
    (SELECT COUNT(*) FROM Airlines) AS total_airlines,
    (SELECT COUNT(*) FROM Airports) AS total_airports,
    (SELECT COUNT(*) FROM Passengers) AS total_passengers,
    (SELECT COUNT(*) FROM Flights) AS total_flights,
    (SELECT COUNT(*) FROM Reservations) AS total_reservations;

-- Revenue Summary
SELECT 
    COUNT(r.reservation_id) AS total_bookings,
    SUM(f.ticket_price) AS total_revenue,
    AVG(f.ticket_price) AS average_ticket_price
FROM Reservations r
INNER JOIN Flights f ON r.flight_id = f.flight_id
WHERE r.status = 'Confirmed';


-- =====================================================
-- SECTION 23: CLEANUP (Optional)
-- =====================================================

-- Cleanup in correct order
DROP VIEW IF EXISTS vw_RevenueSummary;
DROP VIEW IF EXISTS vw_PassengerBookings;
DROP VIEW IF EXISTS vw_FlightDetails;

DROP FUNCTION IF EXISTS fn_GetFlightsByRoute;
DROP FUNCTION IF EXISTS fn_CalculateDiscount;

DROP PROCEDURE IF EXISTS sp_GetPassengerReport;
DROP PROCEDURE IF EXISTS sp_CancelReservation;
DROP PROCEDURE IF EXISTS sp_BookFlight;

DROP TABLE IF EXISTS Booking_Audit_Log;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Reservations;
DROP TABLE IF EXISTS Flights;
DROP TABLE IF EXISTS Passengers;
DROP TABLE IF EXISTS Airports;
DROP TABLE IF EXISTS Airlines;

DROP DATABASE AirlineSystem;

-- =====================================================
-- END OF COMPLETE SQL SCRIPT
-- =====================================================