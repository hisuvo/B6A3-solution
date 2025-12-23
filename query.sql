CREATE DATABASE vehicle_rental_db

create table users(
  user_id serial primary key,
  name varchar(50) not null,
  email varchar(100) unique not null,
  password text not null check (length(password) > 6),
  phone varchar(150) not null,
  role varchar(50) not null default 'Customer' check (role in ('Admin','Customer'))
)

 INSERT INTO users (name, email, password, phone, role)
  VALUES
  ('Rahim Khan', 'rahim.k@email.com', 'RahimAdmin!', '+880-1912345678', 'Admin'),
  ('Arif Hossain', 'arif.hossain@email.com', 'ArifPass123', '+880-1712-556677', 'Customer'),
  ('Fatima Begum', 'fatima.b@email.com', 'Fatima456!', '+880-1815-667788', 'Customer'),
  ('Rajib Ahmed', 'rajib.ahmed@email.com', 'RajibPass7', '+880-1916-778899', 'Customer'),
  ('Tasnim Akter', 'tasnim.a@email.com', 'Tasnim890', '+880-1717-889900', 'Customer'),
  ('Kamal Uddin', 'kamal.u@email.com', 'Kamal123!', '+880-1818-990011', 'Customer'),
  ('Rina Parvin', 'rina.p@email.com', 'RinaP@ss1', '+880-1919-001122', 'Customer'),
  ('Sohel Rana', 'sohel.r@email.com', 'SohelPass23', '+880-1710-112233', 'Customer'),
  ('Mousumi Khan', 'mousumi.k@email.com', 'Mousumi1', '+880-1811-223344', 'Customer'),
  ('Shamim Islam', 'shamim.i@email.com', 'ShamimP@55', '+880-1912-334455', 'Customer'),
  ('Farhana Yeasmin', 'farhana.y@email.com', 'Farhana1234', '+880-1713-445566', 'Customer'),
  ('Rafiqul Alam', 'rafiqul.a@email.com', 'RafiqPass!', '+880-1814-556677', 'Customer'),
  ('Jhorna Begum', 'jhorna.b@email.com', 'Jhorna7', '+880-1915-667788', 'Customer'),


create table vehicles(
  vehicle_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  type VARCHAR(30) NOT NULL CHECK (type IN ('car', 'bike', 'truck')),
  model VARCHAR(100) NOT NULL,
  registration_number VARCHAR(50) UNIQUE NOT NULL,
  rental_price NUMERIC(10,2) CHECK (rental_price >= 0),
  status VARCHAR(20) NOT NULL DEFAULT 'available' CHECK (status IN ('available', 'rented', 'maintenance'))
)

INSERT INTO vehicles (name, type, model, registration_number, rental_price, status)
    VALUES
    ('Toyota Corolla', 'car', 'Corolla X 2023', 'DHAKA-GA-11-1234', 2200.00, 'available'),
    ('Honda Civic', 'bike', 'Civic Turbo 2024', 'DHAKA-GA-11-5678', 2500.00, 'rented'),
    ('Toyota Premio', 'car', 'Premio G 2022', 'DHAKA-GA-12-9012', 2800.00, 'rented'),
    ('Mitsubishi Pajero', 'car', 'Pajero Sport 2023', 'DHAKA-GA-13-3456', 3500.00, 'available'),
    ('Suzuki Ciaz', 'truck', 'Ciaz Alpha 2023', 'DHAKA-GA-14-7890', 1800.00, 'available'),
    ('Nissan Sunny', 'car', 'Sunny Ex 2022', 'CHITTAGONG-CHA-15-2345', 1600.00, 'maintenance'),
    ('Toyota Axio', 'car', 'Axio Hybrid 2023', 'DHAKA-GA-16-6789', 2000.00, 'available'),
    ('Honda City', 'truck', 'City IVTEC 2024', 'DHAKA-GA-17-0123', 2300.00, 'rented'),
    ('Hyundai Elantra', 'bike', 'Elantra Sport 2023', 'DHAKA-GA-18-4567', 2100.00, 'rented'),
    ('MG Hector', 'truck', 'Hector Plus 2023', 'DHAKA-GA-19-8901', 3200.00, 'available')


CREATE TABLE bookings(
  booking_id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
  vehicle_id INT REFERENCES vehicles(vehicle_id) ON DELETE RESTRICT,
  start_date DATE NOT NULL, -- CHECK (start_date >= CURRENT_DATE)
  end_date DATE NOT NULL CHECK ( end_date > start_date ),
  status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'completed', 'cancelled')),
  total_cost NUMERIC(10,2) NOT NULL CHECK(total_cost >= 0)
)


INSERT INTO bookings (user_id, vehicle_id, start_date, end_date, status, total_cost)
    VALUES
    (2, 2, '2024-02-15', '2024-02-18', 'completed', 6600.00),
    (3, 3, '2024-02-20', '2024-02-25', 'confirmed', 17500.00),
    (4, 2, '2024-02-22', '2024-02-27', 'completed', 10000.00),
    (5, 2, '2024-02-18', '2024-02-20', 'confirmed', 4200.00),
    (6, 8, '2024-02-01', '2024-02-05', 'completed', 12800.00),
    (7, 8, '2024-02-10', '2024-02-15', 'cancelled', 12500.00),
    (8, 3, '2024-02-03', '2024-02-07', 'confirmed', 7200.00),
    (9, 9, '2024-02-25', '2024-03-01', 'pending', 15000.00),
    (10, 2, '2024-02-05', '2024-02-08', 'completed', 6600.00),
    (11, 9, '2024-02-12', '2024-02-16', 'pending', 14000.00)


-- Query-1:
  SELECT b.booking_id, u.name AS customer_name, v.name AS vehicle_name, b.start_date, b.end_date, b.status FROM bookings AS b
  INNER JOIN users AS u USING(user_id)
  INNER JOIN vehicles AS v USING(vehicle_id)
  
-- Query-2:
SELECT * FROM vehicles AS v
WHERE NOT EXISTS(
  SELECT * FROM bookings AS b
  WHERE b.vehicle_id = v.vehicle_id
)

-- Query-3:
SELECT * FROM vehicles
WHERE type = 'car' AND status = 'available'

-- Query-4:
SELECT v.name AS vehicle_name, COUNT(b.booking_id) AS total_bookings FROM vehicles AS v
INNER JOIN bookings AS b ON v.vehicle_id = b.vehicle_id
GROUP BY v.name, v.vehicle_id
HAVING COUNT(b.booking_id) > 2
