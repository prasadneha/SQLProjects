create database MakeMyTrip;
use MakeMyTrip;
create table Users(
UserID int primary key,
UserName varchar(50) not null,
Email varchar(100) not null,
PhoneNumber varchar(15),
constraint UC_Email unique(Email)
);

create table Hotels(
HotelID int primary key,
HotelName varchar(100) not null,
Location varchar(50) not null,
Rating decimal(3,2),
constraint UC_HotelName_Location unique(HotelName,Location)
);

create table Bookings(
BookingID int primary key,
UserID int,
HOtelID int,
CheckInDate Date,
CheckOutDate Date,
TotalAmount decimal(10,2),
constraint FK_Booking_User Foreign key(UserID) references Users(UserID),
constraint FK_Booking_Hotel foreign key(HotelID) references Hotels(HotelID)
);

create table Reviews(
ReviewID int primary key,
UserID int,
HotelID int,
Rating decimal(3,2),
Comment text,
constraint FK_Review_User foreign key(UserID) references Users(UserID),
constraint FK_Review_Hotel foreign key(HotelID) references Hotels(HotelID)
);

INSERT INTO Users (UserID, UserName, Email, PhoneNumber)
VALUES
    (1, 'John Doe', 'john.doe@example.com', '+1234567890'),
    (2, 'Jane Smith', 'jane.smith@example.com', '+9876543210');

insert into Hotels(HotelID,HotelName,Location,Rating) values
(101, 'Luxury Inn', 'City A', 4.5),
(102, 'Comfort Suites', 'City B', 3.8);

INSERT INTO Bookings (BookingID, UserID, HotelID, CheckInDate, CheckOutDate, TotalAmount)
VALUES
    (1001, 1, 101, '2023-06-15', '2023-06-20', 1200.00),
    (1002, 2, 102, '2023-07-10', '2023-07-15', 900.50);
    
INSERT INTO Reviews (ReviewID, UserID, HotelID, Rating, Comment)
VALUES
    (501, 1, 101, 4.0, 'Great experience!'),
    (502, 2, 102, 3.5, 'Good service but room cleanliness can be improved.');    
    
--Retrieve all users    
select * from Users;    

--Retrieve all hotels
select * from Hotels;

--Retrieve bookings with user and hotel details
select 
    B.BookingID,
    U.UserName AS GuestName,
    H.HotelName,
    B.CheckInDate,
    B.CheckOutDate,
    B.TotalAmount
FROM
    Bookings B
JOIN
    Users U ON B.UserID = U.UserID
JOIN
    Hotels H ON B.HotelID = H.HotelID;

--Retrieve reviews with user and hotel details
select
R.ReviewId,
U.UserName as ReviewerName,
H.HotelName,
R.Rating
from Reviews R
join
Users U on R.UserID=U.UserID
join
Hotels H on R.HotelID=H.HotelID;
     
