-- Supermarket 

-- 1. DDL (30 pts)
CREATE DATABASE Supermarket
GO
USE Supermarket

--
CREATE TABLE Categories
(
	Id INT PRIMARY KEY IDENTITY
	, [Name] NVARCHAR(30) NOT NULL
)

CREATE TABLE Items
(
	Id INT PRIMARY KEY IDENTITY
	, [Name] NVARCHAR(30) NOT NULL
	, Price DECIMAL(15,2) NOT NULL
	, CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL
)

CREATE TABLE Employees
(
	Id INT PRIMARY KEY IDENTITY
	, FirstName NVARCHAR(50) NOT NULL
	, LastName NVARCHAR(50) NOT NULL
	, Phone CHAR(12) NOT NULL
	, Salary DECIMAL(15,2) NOT NULL
)

CREATE TABLE Orders
(
	Id INT PRIMARY KEY IDENTITY
	, [DateTime] DATETIME NOT NULL
	, EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL
)

CREATE TABLE OrderItems
(
	OrderId INT FOREIGN KEY REFERENCES Orders(Id) NOT NULL
	, ItemId INT FOREIGN KEY REFERENCES Items(Id) NOT NULL
	, Quantity INT CHECK (Quantity > 0) NOT NULL
	
	, PRIMARY KEY (OrderId, ItemId)
	--, CONSTRAINT CHK_Quantity CHECK (Quantity > 0)
)

CREATE TABLE Shifts
(
	Id INT IDENTITY NOT NULL
	, EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL
	, CheckIn DATETIME NOT NULL
	, CheckOut DATETIME NOT NULL
	
	, PRIMARY KEY (Id, EmployeeId)
	, CONSTRAINT CHK_CheckOutAfterIn CHECK (CheckOut > CheckIn)
)
--
--ALTER TABLE Shifts
--ADD CONSTRAINT CH_CheckOutAfterIn CHECK (CheckOut > CheckIn)

-- 2. DML (10 pts)
-- 2. Insert
INSERT INTO Employees (FirstName,	LastName,	Phone,	Salary)
VALUES
('Stoyan'	, 'Petrov'	, '888-785-8573', 	500.25),
('Stamat'	, 'Nikolov'	, '789-613-1122', 	999995.25),
('Evgeni'	, 'Petkov'	, '645-369-9517', 	1234.51),
('Krasimir'	, 'Vidolov'	, '321-471-9982', 	50.25)

INSERT INTO Items(Name,	Price,	CategoryId)
VALUES
('Tesla battery',	154.25,	8),
('Chess',			30.25,	8),
('Juice',			5.32,	1),
('Glasses',			10	,	8),
('Bottle of water',	1	,	1)

-- 3. Update
SELECT *
FROM Items 
WHERE CategoryId IN (1, 2, 3)
--
UPDATE Items
SET Price *= 1.27
WHERE CategoryId IN (1, 2, 3)
 
-- 4. Delete
SELECT *
FROM OrderItems
WHERE OrderId = 48

--
DELETE 
FROM OrderItems
WHERE OrderId = 48


-- 3. Querying (40 pts)
-- 5. Richest People
SELECT Id, FirstName
FROM Employees
WHERE Salary > 6500
ORDER BY FirstName, Id

-- 6. Cool Phone Numbers
SELECT FirstName + ' ' + LastName AS [Full Name], Phone AS [Phone Number]
FROM Employees
WHERE Phone LIKE '3%'
ORDER BY FirstName, Phone

-- 7. Employee Statistics
SELECT FirstName, LastName, COUNT(o.Id) AS [Count]
FROM Employees AS e
	JOIN Orders AS o ON e.Id = o.EmployeeId
GROUP BY e.Id, FirstName, LastName
ORDER BY  [Count] DESC, FirstName

-- 8. Hard Workers Club
SELECT e.FirstName, e.LastName, AVG( DATEDIFF(HOUR, CheckIn, CheckOut)) AS [Work hours]
FROM Employees AS e
	JOIN Shifts AS s ON e.Id = s.EmployeeId
GROUP BY e.Id, e.FirstName, e.LastName
HAVING AVG( DATEDIFF(HOUR, CheckIn, CheckOut)) > 7
ORDER BY [Work hours] DESC, e.Id

-- 9. The Most Expensive Order
SELECT TOP(1) oi.OrderId, SUM(i.Price * oi.Quantity) AS TotalPrice
FROM OrderItems AS oi
	JOIN Items AS i ON oi.ItemId = i.Id 
GROUP BY oi.OrderId
ORDER BY TotalPrice DESC

-- 10. Rich Item, Poor Item
SELECT TOP(10) oi.OrderId, MAX(i.Price) AS ExpensivePrice, MIN(i.Price) AS CheapPrice
FROM OrderItems AS oi
	JOIN Items AS i ON oi.ItemId = i.Id 
GROUP BY oi.OrderId
ORDER BY ExpensivePrice DESC, OrderId

-- 11. Cashiers
SELECT e.Id, e.FirstName, e.LastName
FROM Employees AS e
	JOIN Orders AS o ON e.Id = o.EmployeeId
GROUP BY e.Id, e.FirstName, e.LastName
ORDER BY e.Id
--
SELECT DISTINCT e.Id, e.FirstName, e.LastName
FROM Employees AS e
	JOIN Orders AS o ON e.Id = o.EmployeeId
ORDER BY e.Id

-- 12. Lazy Employees
SELECT DISTINCT e.Id, e.FirstName + ' ' + e.LastName AS [Full Name]
FROM Employees AS e
	JOIN Shifts AS s ON e.Id = s.EmployeeId
WHERE DATEDIFF(HOUR, CheckIn, CheckOut) < 4
ORDER BY e.Id

-- 13. Sellers
SELECT TOP(10) 
	e.FirstName + ' ' + e.LastName AS [Full Name]
	, SUM(i.Price * oi.Quantity) AS TotalPrice
	, SUM(oi.Quantity) AS Items
FROM OrderItems AS oi
	JOIN Items AS i ON oi.ItemId = i.Id 
	JOIN Orders AS o ON oi.OrderId = o.Id
	JOIN Employees AS e ON o.EmployeeId = e.Id
WHERE o.DateTime < '2018-06-15'
GROUP BY e.Id, e.FirstName, e.LastName
ORDER BY TotalPrice DESC, Items DESC

-- 14. Tough days
SELECT 
	e.FirstName + ' ' + e.LastName AS [Full Name]
	, CASE
		WHEN DATEPART ( weekday , CheckIn) = 1 THEN 'Sunday'
		WHEN DATEPART ( weekday , CheckIn) = 2 THEN 'Monday'
		WHEN DATEPART ( weekday , CheckIn) = 3 THEN 'Tuesday'
		WHEN DATEPART ( weekday , CheckIn) = 4 THEN 'Wednesday'
		WHEN DATEPART ( weekday , CheckIn) = 5 THEN 'Thursday'
		WHEN DATEPART ( weekday , CheckIn) = 6 THEN 'Friday'
		WHEN DATEPART ( weekday , CheckIn) = 7 THEN 'Saturday'
	END AS [Day of week]
FROM Employees AS e
	LEFT JOIN Orders AS o ON e.Id = o.EmployeeId
	JOIN Shifts AS s ON e.Id = s.EmployeeId
WHERE DATEDIFF(HOUR, CheckIn, CheckOut) > 12 AND o.EmployeeId IS NULL
ORDER BY e.Id

-- 
SELECT 
	e.FirstName + ' ' + e.LastName AS [Full Name]
	, DATENAME (WEEKDAY , CheckIn)  AS [Day of week]
FROM Employees AS e
	LEFT JOIN Orders AS o ON e.Id = o.EmployeeId
	JOIN Shifts AS s ON e.Id = s.EmployeeId
WHERE DATEDIFF(HOUR, CheckIn, CheckOut) > 12 AND o.EmployeeId IS NULL
ORDER BY e.Id

-- 15. Top Order per Employee
SELECT e.FirstName + ' ' + e.LastName AS [Full Name]
	, DATEDIFF(HOUR, CheckIn, CheckOut) AS [Work hours]
	, TotalPrice
FROM
(
	SELECT o.EmployeeId
		, o.DateTime
		, SUM(i.Price * oi.Quantity) AS TotalPrice
		, ROW_NUMBER() OVER (PARTITION BY o.EmployeeId ORDER BY SUM(i.Price * oi.Quantity) DESC) AS RowNumber 
	FROM Orders AS o
		JOIN OrderItems AS oi ON o.Id = oi.OrderId
		JOIN Items AS i ON oi.ItemId = i.Id
	GROUP BY o.Id, o.EmployeeId, o.DateTime
) AS ts
	LEFT JOIN Employees AS e ON ts.EmployeeId = e.Id
	LEFT JOIN Shifts AS s ON e.Id = s.EmployeeId
WHERE RowNumber = 1 AND [DateTime] BETWEEN s.CheckIn AND s.CheckOut -- DATEDIFF(DAY,[DateTime], s.CheckIn) = 0 -- <-- not working
ORDER BY [Full Name], [Work hours] DESC, TotalPrice DESC

--16. Average Profit per Day
--Find the average profit for each day. Select the day of month and average daily profit of sold products.
--Sort them by day of month (ascending) and format the profit to the second digit after the decimal point.
SELECT DATEPART(DAY, o.DateTime) AS [Day]
	--, STR( AVG(i.Price * oi.Quantity), 15, 2) AS [Total profit]
	, FORMAT( AVG(i.Price * oi.Quantity), 'N2') AS [Total profit]
FROM Orders AS o
	JOIN OrderItems AS oi ON o.Id = oi.OrderId
	JOIN Items AS i ON oi.ItemId = i.Id
GROUP BY DATEPART(DAY, o.DateTime)
ORDER BY [Day]

--Example
--Day	Total profit
--1	254.79
--3	211.49
--4	115.89
--5	83.26
--6	111.47
--7	101.49
--8	140.65
--10	90.17
--11	281.59
--12	162.31
--13	127.65

--17. Top Products
--Find information about all products. Select their name, category, how many of them were sold and the total profit they produced.
--Sort them by total profit (descending) and their count (descending)
SELECT i.[Name] AS Item
	, c.[Name] AS Category
	, SUM( oi.Quantity ) AS [Count]
	, SUM( oi.Quantity * i.Price )  AS TotalPrice
FROM Items AS i
	JOIN Categories AS c ON i.CategoryId = c.Id
	LEFT JOIN OrderItems AS oi ON i.Id = oi.ItemId
GROUP BY i.Id, i.[Name], c.[Name]
ORDER BY TotalPrice DESC, [Count] DESC

--Example
--Item	Category	Count	TotalPrice
--TV	Miscellaneous	308	110880.00
--Tires	Miscellaneous	524	78600.00
--Mattress	Miscellaneous	298	29800.00
--Camera	Miscellaneous	352	28160.00
--…	…	…	…


--Section 4. Programmability (20 pts)
--18. Promotion days
--Create a user defined function, named udf_GetPromotedProducts(@CurrentDate, @StartDate, @EndDate, @Discount, @FirstItemId, @SecondItemId, @ThirdItemId), that receives a current date, a start date for the promotion, an end date for the promotion, a discount, a first item id, a second item id and third item id.
--The function should print the discounted price of the items, based on these conditions:
--•	The first, second and third items must exist in the database.
--•	The current date must be between the start date and end date.
--If both conditions are true, you must discount the price and print the following message in the format:
--•	 “{FirstItemName} price: {@FirstItemPrice} <-> {SecondItemName} price: {@SecondItemPrice} <-> {ThirdItemName} price: {@ThirdItemPrice}”
--If one of the items is not in the database, the function should return “One of the items does not exists!”
--If the current date is not between the start date and end date, the function should return “The current date is not within the promotion dates!”
--Note: Do not update any records in the database!
CREATE FUNCTION udf_GetPromotedProducts
	( @CurrentDate DATE
	, @StartDate DATE
	, @EndDate DATE
	, @Discount INT
	, @FirstItemId INT
	, @SecondItemId INT
	, @ThirdItemId INT) 
RETURNS NVARCHAR(100)
AS
BEGIN
	DECLARE @FirstName NVARCHAR(30) = (SELECT Name FROM Items WHERE Id = @FirstItemId)
	DECLARE @SecondName NVARCHAR(30) = (SELECT Name FROM Items WHERE Id = @SecondItemId)
	DECLARE @ThirdName NVARCHAR(30) = (SELECT Name FROM Items WHERE Id = @ThirdItemId)

	IF(@FirstName IS NULL OR @SecondName IS NULL OR @ThirdName IS NULL)
	BEGIN
		--RAISERROR('One of the items does not exists!', 16, 1)
		RETURN 'One of the items does not exists!'
	END

	IF(@CurrentDate NOT BETWEEN @StartDate AND @EndDate)
	BEGIN
		--RAISERROR('The current date is not within the promotion dates!', 16, 2)
		RETURN 'The current date is not within the promotion dates!'
	END

	DECLARE @Disc DECIMAL(15, 2) = (100 - @Discount) * 0.01

	DECLARE @FirstPrice DECIMAL(15, 2) = (SELECT Price FROM Items WHERE Id = @FirstItemId) * @Disc
	DECLARE @SecondPrice DECIMAL(15, 2) = (SELECT Price FROM Items WHERE Id = @SecondItemId) * @Disc
	DECLARE @ThirdPrice DECIMAL(15, 2) = (SELECT Price FROM Items WHERE Id = @ThirdItemId) * @Disc

	RETURN @FirstName + ' price: ' + FORMAT(@FirstPrice, 'N2') + ' <-> ' 
		+ @SecondName + ' price: ' + FORMAT(@SecondPrice, 'N2') + ' <-> ' 
		+ @ThirdName + ' price: ' + FORMAT(@ThirdPrice, 'N2')
END

--Example:
--Query				
SELECT dbo.udf_GetPromotedProducts('2018-08-02', '2018-08-01', '2018-08-03',13, 3,4,5)
--Output
--Water price: 0.74 <-> Juice price: 1.31 <-> Ayran price: 4.35

--Query
SELECT dbo.udf_GetPromotedProducts('2018-08-01', '2018-08-02', '2018-08-03',13,3 ,4,5)
--Output
--The current date is not within the promotion dates!


--19. Cancel order
--Create a user defined stored procedure, named usp_CancelOrder(@OrderId, @CancelDate), that receives an order id and date, and attempts to delete the current order. An order will only be deleted if all of these conditions pass:
--•	If the order doesn’t exists, then it cannot be deleted. Raise an error with the message “The order does not exist!”
--•	If the cancel date is 3 days after the issue date, raise an error with the message “You cannot cancel the order!”
--If all the above conditions pass, delete the order.

CREATE PROC usp_CancelOrder(@OrderId INT, @CancelDate DATETIME)
AS
BEGIN
	DECLARE @orderDate DATETIME = (SELECT DateTime FROM Orders WHERE Id = @OrderId)

	IF(@orderDate IS NULL)
	BEGIN
		RAISERROR('The order does not exist!', 16, 1)
		RETURN
	END

	IF(DATEDIFF(DAY, @orderDate, @CancelDate) >= 3 )
	BEGIN
		RAISERROR('You cannot cancel the order!', 16, 2)
		RETURN
	END

	BEGIN TRANSACTION
		DELETE 
		FROM OrderItems
		WHERE OrderId = @OrderId

		DELETE 
		FROM Orders
		WHERE Id = @OrderId
	COMMIT
END


--Example usage:
--Query	Output
EXEC usp_CancelOrder 1, '2018-06-02'
SELECT COUNT(*) FROM Orders
SELECT COUNT(*) FROM OrderItems	
--998
--2455
EXEC usp_CancelOrder 1, '2018-06-15' --	You cannot cancel the order!
EXEC usp_CancelOrder 124231, '2018-06-15'	-- The order does not exist!


--20. Deleted Order
--Create a new table “DeletedOrders” with columns (OrderId, ItemId, ItemQuantity). Create a trigger, which fires when order is deleted. After deleting the order, insert all of the data into the new table “DeletedOrders”.

--Note: Submit only your CREATE TRIGGER statement!

CREATE TABLE DeletedOrders
(
	Id INT PRIMARY KEY IDENTITY
	, OrderId INT
	, ItemId INT
	, ItemQuantity INT
)

DROP TABLE DeletedOrders

CREATE TRIGGER tr_DeletedOrders ON OrderItems AFTER DELETE
AS
	INSERT INTO DeletedOrders (OrderID, ItemId, ItemQuantity)
	SELECT OrderId, ItemId, Quantity FROM deleted

--Example usage:
--Query
DELETE FROM OrderItems
WHERE OrderId = 5

DELETE FROM Orders
WHERE Id = 5 
--Response
--(5 rows affected)

--(5 rows affected)

--(1 rows affected)

