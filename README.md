All Lab program source files and CSV's from DBMS Lab.


















CREATE DATABASE hotel_booking_system;
USE hotel_booking_system;

CREATE TABLE hotel (
    hotel_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    category VARCHAR(50)
);

CREATE TABLE guest (
    guest_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_no VARCHAR(15),
    address VARCHAR(200)
);

CREATE TABLE room (
    hotel_id INT,
    room_no INT,
    room_type VARCHAR(50),
    capacity INT CHECK (capacity > 0),
    price_per_night DECIMAL(10,2) CHECK (price_per_night >= 0),
    PRIMARY KEY (hotel_id, room_no),
    FOREIGN KEY (hotel_id) REFERENCES hotel(hotel_id)
        ON DELETE RESTRICT
);

CREATE TABLE reservation (
    reservation_id INT PRIMARY KEY,
    guest_id INT NOT NULL,
    hotel_id INT NOT NULL,
    room_no INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    booking_status VARCHAR(30),
    FOREIGN KEY (guest_id) REFERENCES guest(guest_id)
        ON DELETE RESTRICT,
    FOREIGN KEY (hotel_id, room_no)
        REFERENCES room(hotel_id, room_no)
        ON DELETE RESTRICT,
    CHECK (check_out_date > check_in_date)
);

CREATE TABLE payment (
    payment_id INT PRIMARY KEY,
    reservation_id INT UNIQUE,
    payment_date DATE NOT NULL,
    payment_mode VARCHAR(50),
    amount DECIMAL(10,2) CHECK (amount >= 0),
    FOREIGN KEY (reservation_id)
        REFERENCES reservation(reservation_id)
        ON DELETE RESTRICT
);

INSERT INTO hotel VALUES
(1, 'Grand Palace', 'Bengaluru', '5-Star'),
(2, 'City Inn', 'Mysuru', '3-Star');

INSERT INTO guest VALUES
(101, 'Rahul Sharma', '9876543210', 'Bengaluru'),
(102, 'Ananya Rao', '9123456780', 'Mysuru'),
(103, 'Karan Mehta', '9988776655', 'Delhi');

INSERT INTO room VALUES
(1, 101, 'Deluxe', 2, 4500),
(1, 102, 'Suite', 4, 8000),
(2, 201, 'Standard', 2, 2500),
(2, 202, 'Deluxe', 3, 4000);

INSERT INTO reservation VALUES
(1001, 101, 1, 101, '2025-01-10', '2025-01-12', 'Confirmed'),
(1002, 102, 1, 102, '2025-01-15', '2025-01-18', 'Confirmed'),
(1003, 103, 2, 201, '2025-01-20', '2025-01-22', 'Pending');

INSERT INTO payment VALUES
(5001, 1001, '2025-01-09', 'UPI', 9000),
(5002, 1002, '2025-01-14', 'Card', 24000);
