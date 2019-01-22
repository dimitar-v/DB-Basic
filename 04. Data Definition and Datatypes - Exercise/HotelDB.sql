-- 15 Hotel Database

CREATE DATABASE Hotel
GO
USE Hotel

-- for Judge from here

-- DROP TABLE Employees  
CREATE TABLE Employees  
(
	Id INT IDENTITY,
	FirstName NVARCHAR(50) NOT NULL, 
	LastName NVARCHAR(50) NOT NULL, 
	Title VARCHAR(5), 
	Notes NVARCHAR(MAX),
	CONSTRAINT PK_Employees PRIMARY KEY (Id)
)

INSERT INTO Employees VALUES
('Иван', 'Георгиев', 'Mr.', NULL),
('Живка', 'Здравкова', 'Ms.', NULL),
('Георги', 'Любенов', 'Mr.', NULL)

SELECT * FROM Employees 

-- DROP TABLE Customers   
CREATE TABLE Customers   
(
	AccountNumber BIGINT NOT NULL,
	FirstName NVARCHAR(50) NOT NULL, 
	LastName NVARCHAR(50) NOT NULL, 
	PhoneNumber VARCHAR(20),
	EmergencyName NVARCHAR(100), 
	EmergencyNumber VARCHAR(20), 
	Notes NVARCHAR(MAX),
	CONSTRAINT PK_Customers PRIMARY KEY (AccountNumber)
)

INSERT INTO Customers VALUES
(123123123, 'Иван', 'Запрянов', '+359 8799 89 202 ', 'Vankata', '+359 32 123456', NULL),
(100000007, 'James', 'Bond', '+44 020 0007 00007', 'Agent007', '+44 020 0001 0001', NULL),
(4466121266, 'Захари', 'Стоянов', '+359 678 012 456', 'Stoianov', '+359 2 89 123 567', NULL)

SELECT * FROM Customers  


-- DROP TABLE RoomStatus

CREATE TABLE RoomStatus
(
	RoomStatus NVARCHAR(15), 
	Notes NVARCHAR(MAX),
	CONSTRAINT PK_RoomStatus PRIMARY KEY (RoomStatus)
)

INSERT INTO RoomStatus (RoomStatus)
VALUES
	('Booked'),
    ('Occupied'),
    ('Available')

SELECT * FROM RoomStatus  

-- DROP TABLE RoomTypes 

CREATE TABLE RoomTypes 
(
	RoomType NVARCHAR(15), 
	Notes NVARCHAR(MAX),
	CONSTRAINT PK_RoomTypes PRIMARY KEY (RoomType)
)

INSERT INTO RoomTypes (RoomType)
VALUES
	('Single'),
    ('Double'),
    ('Suite')

SELECT * FROM RoomTypes  

-- DROP TABLE BedTypes  

CREATE TABLE BedTypes  
(
	BedType NVARCHAR(15), 
	Notes NVARCHAR(MAX),
	CONSTRAINT PK_BedTypes PRIMARY KEY (BedType)
)

INSERT INTO BedTypes (BedType)
VALUES
	('Standart'),
    ('Double'),
    ('King')

SELECT * FROM BedTypes  

-- DROP TABLE Rooms   

CREATE TABLE Rooms   
(
	RoomNumber INT, 
	RoomType NVARCHAR(15) NOT NULL, 
	BedType NVARCHAR(15) NOT NULL, 
	Rate MONEY, 
	RoomStatus NVARCHAR(15) NOT NULL, 
	Notes NVARCHAR(MAX),
	CONSTRAINT PK_Rooms PRIMARY KEY (RoomNumber),
	CONSTRAINT FK_RoomType FOREIGN KEY (RoomType) REFERENCES RoomTypes (RoomType),
	CONSTRAINT FK_BedType FOREIGN KEY (BedType) REFERENCES BedTypes (BedType),
	CONSTRAINT FK_RoomStatus FOREIGN KEY (RoomStatus) REFERENCES RoomStatus (RoomStatus),
	CONSTRAINT CHK_Rate CHECK (Rate >= 0)
)

INSERT INTO Rooms VALUES
(100, 'Suite', 'King', 150, 'Booked', NULL),
(110, 'Double', 'Double', 110, 'Available', NULL),
(111, 'Single', 'Standart', 50, 'Occupied', NULL)

SELECT * FROM Rooms   

-- DROP TABLE Payments

CREATE TABLE Payments(
    Id INT IDENTITY, 
    EmployeeId INT NOT NULL, 
    PaymentDate DATETIME NOT NULL, 
    AccountNumber BIGINT NOT NULL, 
    FirstDateOccupied DATE NOT NULL, 
    LastDateOccupied DATE NOT NULL, 
    TotalDays AS DATEDIFF(DAY, FirstDateOccupied, LastDateOccupied),
    AmountCharged DECIMAL(6,2) NOT NULL, 
    TaxRate DECIMAL(6,2) NOT NULL, 
    TaxAmount DECIMAL(6,2) NOT NULL, 
    PaymentTotal AS AmountCharged + TaxRate + TaxAmount, 
    NOTES NVARCHAR(MAX),
    CONSTRAINT PK_Payments PRIMARY KEY (Id), 
    CONSTRAINT FK_Employee FOREIGN KEY (EmployeeId) REFERENCES Employees (Id), 
    CONSTRAINT FK_AccountNumber FOREIGN KEY (AccountNumber) REFERENCES Customers (AccountNumber),
    CONSTRAINT CHK_EndDate CHECK (LastDateOccupied > FirstDateOccupied)
)

INSERT INTO Payments(EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, AmountCharged, TaxRate, TaxAmount)
VALUES
(1, CONVERT([datetime], '20-01-2019', 104), 123123123, CONVERT([datetime], '19-01-2019', 104), CONVERT([datetime], '20-01-2019', 104), 100, 10, 5),
(2, GETDATE(), 100000007, CONVERT([datetime], '15-01-2019', 104), CONVERT([datetime], '22-01-2019', 104), 135, 15, 7),
(3, CONVERT([datetime], '02-02-2019', 104), 4466121266, CONVERT([datetime], '02-02-2019', 104), CONVERT([datetime], '05-02-2019', 104), 100, 10, 5)

SELECT * FROM Payments


-- DROP TABLE Occupancies

CREATE TABLE Occupancies(
    Id INT IDENTITY, 
    EmployeeId INT NOT NULL, 
    DateOccupied DATE NOT NULL, 
    AccountNumber BIGINT NOT NULL, 
    RoomNumber INT NOT NULL, 
    RateApplied DECIMAL(6,2) NOT NULL,
    PhoneCharge DECIMAL(6,2) NOT NULL, 
    NOTES NVARCHAR(MAX),
    CONSTRAINT PK_Occupancies PRIMARY KEY (Id), 
    CONSTRAINT FK_Employees FOREIGN KEY (EmployeeId) REFERENCES Employees (Id), 
    CONSTRAINT FK_Customers FOREIGN KEY (AccountNumber) REFERENCES Customers (AccountNumber), 
    CONSTRAINT FK_RoomNumber FOREIGN KEY (RoomNumber) REFERENCES Rooms (RoomNumber),
    CONSTRAINT CHK_PhoneCharge CHECK (PhoneCharge >= 0) 
)

INSERT INTO Occupancies (EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge)
VALUES
	(1, CONVERT([datetime], '19-01-2019', 104), 123123123, 110, 110, 0),
	(2, CONVERT([datetime], '15-01-2019', 104), 100000007, 100, 150, 15.50),
	(3, CONVERT([datetime], '02-02-2019', 104), 4466121266, 110, 110, 0)

SELECT * FROM Occupancies 


-- 23 Decrease Tax Rate

UPDATE Payments SET TaxRate *= 0.97
SELECT TaxRate FROM Payments 


-- 24 Delete All Records

TRUNCATE TABLE Occupancies