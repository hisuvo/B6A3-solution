# Vehicle Rental System - Database Design & SQL Queries

## Overview & Objectives

## Database Schema

The system consists of three core tables with the following relationships:

#### 1. Users Table

    Stores information about all system users including both customers and administrators.

##### Columns:

- user_id (SERIAL PRIMARY KEY) - Unique identifier for each user
- name (VARCHAR(50)) - User's full name
- email (VARCHAR(100) UNIQUE) - User's email address (must be unique)
- phone (VARCHAR(20)) - Contact phone number
- role (VARCHAR(20)) - User role (either 'Admin' or 'Customer')

#### 2. Vehicles Table

    Maintains the complete inventory of available vehicles for rent.

##### Columns:

- vehicle_id (SERIAL PRIMARY KEY) - Unique identifier for each vehicle
- name (VARCHAR(50)) - Vehicle name/brand
- type (VARCHAR(20)) - Vehicle type ('car', 'bike', or 'truck')
- model (VARCHAR(30)) - Vehicle model year/version
- registration_number (VARCHAR(50) UNIQUE) - Unique registration plate number
- rental_price (INT) - Daily rental price
- status (VARCHAR(20)) - Current availability status ('available', 'rented', or 'maintenance')

#### 3. Bookings Table

    Records all rental bookings and their transaction details.

##### Columns:

- booking_id (SERIAL PRIMARY KEY) - Unique identifier for each booking
- user_id (INT REFERENCES users) - Foreign key linking to the customer
- vehicle_id (INT REFERENCES vehicles) - Foreign key linking to th- rented vehicle
- start_date (DATE) - Rental start date
- end_date (DATE) - Rental end date
- status (VARCHAR(20)) - Booking status ('pending', 'confirmed', 'completed', or 'cancelled')
- total_cost (NUMERIC(10,2)) - Total rental cost for the booking period

## Entity Relationships

- Users Bookings: One-to-Many relationship (one user can make multiple bookings)
- Vehicles Bookings: One-to-Many relationship (one vehicle can have multiple bookings over time)
- Each Booking: Links exactly one user to one vehicle for a specific time period

## SQL Queries Explained

### Query 1: JOIN

Requirement: Retrieve booking information along with Customer name and Vehicle name.
Concepts Used: INNER JOIN
Query:

        SELECT b.booking_id, u.name AS customer_name, v.name AS vehicle_name, b.start_date, b.end_date, b.status FROM bookings AS b
        INNER JOIN users AS u USING(user_id)
        INNER JOIN vehicles AS v USING(vehicle_id)

Explanation:

- Joins three tables (bookings, users, vehicles) to consolidate related information
- Uses INNER JOIN to match bookings with corresponding user and vehicle records
- Returns only bookings that have valid user and vehicle references
- Provides a complete view of each booking with human-readable customer and vehicle names

### Query 2: EXISTS

Requirement: Find all vehicles that have never been booked.
Concepts used: NOT EXISTS
Query:

        SELECT * FROM vehicles AS v
        WHERE NOT EXISTS(
            SELECT * FROM bookings AS b
            WHERE b.vehicle_id = v.vehicle_id
        )

Explanation:

- Uses NOT EXISTS to find vehicles without any matching records in the bookings table
- The subquery checks for any booking entries associated with each vehicle
- Returns vehicles that have never been rented (no matching vehicle_id in bookings)
- Helps identify new inventory or vehicles that may need marketing attention

### Query 3: WHERE

Requirement: Retrieve all available vehicles of a specific type (e.g. cars).
Concepts used: SELECT, WHERE
Query:

        SELECT * FROM vehicles
        WHERE type = 'car' AND status = 'available'

Explanation:

- Applies multiple filter conditions using the WHERE clause
- Filters by vehicle type (in this example, 'car') and availability status ('available')
- Returns only vehicles that match both conditions
- This query pattern can be easily modified to search for 'bike' or 'truck' types
- Essential for showing customers only the vehicles they can currently rent

### Query 4: GROUP BY and HAVING

Requirement: Find the total number of bookings for each vehicle and display only those vehicles that have more than 2 bookings.
Concepts used: GROUP BY, HAVING, COUNT
Query:

        SELECT v.name AS vehicle_name, COUNT(b.booking_id) AS total_bookings FROM vehicles AS v
        INNER JOIN bookings AS b ON v.vehicle_id = b.vehicle_id
        GROUP BY v.name, v.vehicle_id
        HAVING COUNT(b.booking_id) > 2

Explanation:

- Groups booking records by vehicle name using GROUP BY
- Counts the number of bookings for each vehicle using COUNT(b.booking_id)
- The HAVING clause filters the grouped results to show only vehicles with more than 2 bookings
- Different from WHERE: HAVING filters aggregated data after grouping, while WHERE filters rows before grouping
- Useful for identifying high-demand vehicles that may need additional inventory or pricing optimization
