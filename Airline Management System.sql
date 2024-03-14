create database Airlines;
use Airlines;

CREATE TABLE Airlines (
    AirlineID INT PRIMARY KEY,
    AirlineName VARCHAR(255) NOT NULL,
    Headquarters VARCHAR(255),
    ContactNumber VARCHAR(20)
);

CREATE TABLE Aircrafts (
    AircraftID INT PRIMARY KEY,
    AircraftType VARCHAR(255) NOT NULL,
    RegistrationNumber VARCHAR(20) NOT NULL,
    Capacity INT NOT NULL,
    CurrentStatus VARCHAR(20) DEFAULT 'Active',
    AirlineID INT,
    FOREIGN KEY (AirlineID) REFERENCES Airlines(AirlineID)
);

CREATE TABLE Flights (
    FlightID INT PRIMARY KEY,
    FlightNumber VARCHAR(10) NOT NULL,
    DepartureAirport VARCHAR(255) NOT NULL,
    ArrivalAirport VARCHAR(255) NOT NULL,
    DepartureTime DATETIME NOT NULL,
    ArrivalTime DATETIME NOT NULL,
    AirlineID INT,
    AircraftID INT,
    FOREIGN KEY (AirlineID) REFERENCES Airlines(AirlineID),
    FOREIGN KEY (AircraftID) REFERENCES Aircrafts(AircraftID)
);

CREATE TABLE Passengers (
    PassengerID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(255),
    Phone VARCHAR(20),
    UNIQUE (Email, Phone)
);

CREATE TABLE Reservations (
    ReservationID INT,
    PassengerID INT,
    FlightID INT,
    SeatNumber VARCHAR(10),
    ReservationTime DATETIME NOT NULL,
    PRIMARY KEY (PassengerID, FlightID),
    FOREIGN KEY (PassengerID) REFERENCES Passengers(PassengerID),
    FOREIGN KEY (FlightID) REFERENCES Flights(FlightID)
);

INSERT INTO Airlines (AirlineID, AirlineName, Headquarters, ContactNumber) VALUES
(1, 'Airline A', 'City A', '123-456-7890'),
(2, 'Airline B', 'City B', '987-654-3210');


INSERT INTO Aircrafts (AircraftID, AircraftType, RegistrationNumber, Capacity, CurrentStatus, AirlineID) VALUES
(1, 'Boeing 737', 'ABC123', 150, 'Active', 1),
(2, 'Airbus A320', 'XYZ789', 180, 'Active', 2);

INSERT INTO Flights (FlightID, FlightNumber, DepartureAirport, ArrivalAirport, DepartureTime, ArrivalTime, AirlineID, AircraftID) VALUES
(1, 'AA101', 'JFK', 'LAX', '2023-01-01 08:00:00', '2023-01-01 12:00:00', 1, 1),
(2, 'BA202', 'LHR', 'CDG', '2023-01-02 10:00:00', '2023-01-02 12:30:00', 2, 2);

INSERT INTO Passengers (PassengerID, FirstName, LastName, Email, Phone) VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '555-1234'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '555-5678');

INSERT INTO Reservations (ReservationID, PassengerID, FlightID, SeatNumber, ReservationTime) VALUES
(1, 1, 1, 'A1', '2023-01-01 07:30:00'),
(2, 2, 2, 'B3', '2023-01-02 09:45:00');

--Retrieve information about all airlines
select * from Airlines;

--Retrieve information about all aircraft
select * from Aircrafts;

--Retrieve a list of passengers for a specific flight
select Passengers.* from Passengers
join Reservations on Passengers.PassengerID=Reservations.PassengerID
where Reservations.FlightID=1;

--Retrieve a list of flights for a specific airline
select * from Flights where AirlineID=1;

--Retrieve available seats for a specific flight
select Flights.FlightNumber,Flights.DepartureTime,
Flights.ArrivalTime,Flights.DepartureAirport,
Flights.ArrivalAirport,Flights.AircraftID,Aircrafts.Capacity 
from Flights
join Aircrafts on Flights.AircraftID=Aircrafts.AircraftID
left join Reservations on Flights.FlightID=Reservations.FlightID
where Flights.FlightID=Reservations.FlightID
 and (Reservations.ReservationID
is null or Reservations.ReservationTime < now());

--Retrieve the total number of reservations for a specific flight
select count(*) as reservationCount
from Reservations
where FlightID=1;

--Retrieve a list of passengers with their flight details for a specific airline
select Passengers.firstName,Passengers.LastName, Flights.FlightNumber,
Flights.DepartureAirport,Flights.ArrivalAirport
from Passengers
join Reservations on Passengers.PassengerID=Reservations.PassengerId
join Flights on Reservations.FlightID=Flights.FlightID
where Flights.AirlineID=1;
