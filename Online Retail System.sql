create database Retail;
Use Retail;
create table Customers(
CustomerID int primary key,
FirstName varchar(50),
LastName varchar(50),
Email varchar(100) unique,
Phone varchar(20),
Address varchar(255)
);
create table Categories(
CategoryID int primary key,
CategoryName varchar(50)
);
create table Products(
ProductID int primary key,
ProductName varchar(100),
Description TEXT,
Price Decimal(10,2),
StockQuantity int,
categoryId int,
Foreign key(CategoryID) references Categories(CategoryID)
);
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    Status VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Subtotal DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
INSERT INTO Categories (CategoryID, CategoryName)
VALUES
    (1, 'Electronics'),
    (2, 'Clothing'),
    (3, 'Home and Garden');
    INSERT INTO Products (ProductID, ProductName, Description, Price, StockQuantity, CategoryID)
VALUES
    (1, 'Laptop', 'High-performance laptop', 999.99, 50, 1),
    (2, 'T-Shirt', 'Cotton T-shirt', 19.99, 100, 2),
    (3, 'LED TV', 'Smart LED TV', 499.99, 30, 1);
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, Status)
VALUES
    (1, 1, '2023-01-01', 999.99, 'Completed'),
    (2, 2, '2023-02-01', 39.98, 'Pending'),
 (3, 1, '2023-03-01', 999.99, 'In-Tansit'),
    (4, 2, '2023-03-01', 39.98, 'In-Transit');
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, Subtotal)
VALUES
    (1, 1, 1, 1, 999.99),
    (2, 1, 2, 2, 39.98),
 (3, 2, 3, 1, 900.99)


use Retail;
with ProductSalesRank as(
Select 
Products.ProductID,
Products.ProductName,
sum(orderitems.Quantity) as TotalSales,
Rank() over (order by sum(orderitems.Quantity) desc) as SalesRank
from OrderItems
join 
Products on Orderitems.ProductID=Products.ProductID
group by
Products.ProductID, Products.ProductName
)
select ProductID,
ProductName,
TotalSales
From ProductSalesRank
where
SalesRank=1;

select 
year(OrderDate) as OrderYear,
Month(OrderDate) as OrderMonth,
count(*) as NumberOfOrders
from
Orders
group by
year(OrderDate), Month(OrderDate)
Order by
OrderYear, OrderMonth;

select 
sum(orderitems.Quantity * orderitems.Subtotal) as TotalRevenue
from
Orders
join
orderitems on Orders.OrderID=orderitems.OrderID
where
Orders.OrderDate >= '2023-01-01' and Orders.OrderDate < '2023-02-01';

select 
Orders.OrderID,
orders.OrderDate,
customers.CustomerID,
customers.FirstName,
customers.LastName,
orderitems.ProductID,
products.ProductName,
orderitems.Quantity,
orderitems.Subtotal,
orderitems.Quantity* orderitems.Subtotal as TotalSubtotal
from Orders
join
customers on Orders.CustomerID = Customers.CustomerID
join
orderitems on Orders.OrderID= orderitems.OrderID
join
Products on orderitems.ProductID=products.ProductID;

Select 
ProductID,
ProductName,
CategoryName,
Price
from
Products p
inner join categories c 
on p.CategoryID=c.CategoryID
where CategoryName='Electronics';

Select 
ProductID,
ProductName,
Price,
StockQuantity
from
Products
where
ProductName='Laptop';

Select
Orders.OrderID,
Orders.OrderDate,
Orders.TotalAmount,
orderitems.ProductID,
Products.ProductName,
orderitems.Quantity,
orderitems.Subtotal
from
Orders
join
customers on orders.CustomerID=customers.CustomerID
join
orderitems on Orders.OrderID=orderitems.OrderID
join
Products on orderitems.ProductID= products.ProductID
where
customers.CustomerID=1;