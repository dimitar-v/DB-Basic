-- 14 Car Rental Database

CREATE DATABASE CarRental
GO
USE CarRental

-- for Judge from here

CREATE TABLE Categories 
(
	Id INT IDENTITY,
	CategoryName NVARCHAR(50) NOT NULL, 
	DailyRate DECIMAL(2, 1), 
	WeeklyRate DECIMAL(2, 1), 
	MonthlyRate DECIMAL(2, 1), 
	WeekendRate DECIMAL(2, 1),
	CONSTRAINT PK_Directors PRIMARY KEY (Id),
	CONSTRAINT CHK_DailyRate CHECK (DailyRate <= 10),
	CONSTRAINT CHK_WeeklyRate CHECK (WeeklyRate <= 10),
	CONSTRAINT CHK_MonthlyRate CHECK (MonthlyRate <= 10),
	CONSTRAINT CHK_WeekendRate CHECK (WeekendRate <= 10)
)

INSERT INTO Categories VALUES
('ELECTRIC', 9.9, 8.1, 8.7, 5.4),
('PETROL', 7.8, 6.4, 6.7, 8.0),
('DISEL', 8.1, 6.1, 7.9, 9.0)

SELECT * FROM Categories

-- DROP TABLE Cars 
CREATE TABLE Cars  
(
	Id INT IDENTITY,
	PlateNumber NVARCHAR(15) NOT NULL, 
	Manufacturer NVARCHAR(30) NOT NULL, 
	Model NVARCHAR(30) NOT NULL, 
	CarYear INT NOT NULL, 
	CategoryId INT NOT NULL, 
	Doors INT NOT NULL, 
	Picture VARBINARY(MAX), 
	Condition NVARCHAR(MAX), 
	Available BIT NOT NULL,
	CONSTRAINT PK_Genres PRIMARY KEY (Id),
	CONSTRAINT FK_Category FOREIGN KEY (CategoryId) REFERENCES Categories (Id),
	CONSTRAINT CHK_YearMin CHECK (CarYear >= 2010),
	CONSTRAINT CHK_Doors CHECK (Doors > 0 AND Doors <= 6),
	CONSTRAINT CHK_PictureSize CHECK (DATALENGTH(Picture) <= 1024 * 1024)
)

INSERT INTO Cars VALUES
('СВ 1358 РА', 'Mercedes', 'GLA 220d', 2017, 3, 5, NULL, 'Комфортна за дълъг преход.', 1),
('РВ 0903 МХ', 'Honda', 'Civic TypeR', 2018, 2, 5, NULL, 'Бързина и лукс.', 1),
('СВ 7733 XX', 'Toyota', 'Prius', 2015, 3, 4, NULL, 'Икономичена и семейна кола.', 0)

SELECT * FROM Cars

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
	Id INT IDENTITY,
	DriverLicenceNumber NVARCHAR(20) NOT NULL, 
	FullName NVARCHAR(100) NOT NULL, 
	Address NVARCHAR(200), 
	City NVARCHAR(50), 
	ZIPCode NVARCHAR(20),
	Notes NVARCHAR(MAX),
	CONSTRAINT PK_Customers PRIMARY KEY (Id)
)

INSERT INTO Customers VALUES
('252588667', 'Иван Запрянов', 'Някъде', 'София', '1003', NULL),
('000000007', 'James Bond', 'Mi6', 'London', 'CL007', NULL),
('4466121266', 'Захари Стоянов', NULL, 'Пловдив', '4004', NULL)

SELECT * FROM Customers  

-- DROP TABLE RentalOrders  
CREATE TABLE RentalOrders  
(
	Id INT IDENTITY,
	EmployeeId INT NOT NULL, 
	CustomerId INT NOT NULL, 
	CarId INT NOT NULL, 
	TankLevel INT NOT NULL, 
	KilometrageStart INT NOT NULL, 
	KilometrageEnd INT NOT NULL, 
	TotalKilometrage AS KilometrageEnd - KilometrageStart, 
	StartDate DATE NOT NULL, 
	EndDate DATE NOT NULL, 
	TotalDays AS DATEDIFF(DAY, StartDate, EndDate), 
	RateApplied MONEY NOT NULL, 
	TaxRate MONEY NOT NULL, 
	OrderStatus NVARCHAR(50) NOT NULL,
	Notes NVARCHAR(MAX),
	CONSTRAINT PK_RentalOrders PRIMARY KEY (Id),
	CONSTRAINT FK_Employees FOREIGN KEY (EmployeeId) REFERENCES Employees (Id),
	CONSTRAINT FK_Customers FOREIGN KEY (CustomerId) REFERENCES Customers (Id),
	CONSTRAINT FK_Cars FOREIGN KEY (CarId) REFERENCES Cars (Id),
	CONSTRAINT CHK_TankLevel CHECK (TankLevel >= 0),
    CONSTRAINT CHK_Dates CHECK (EndDate > StartDate),
    CONSTRAINT CHK_Kilometrage CHECK (KilometrageEnd >= KilometrageStart)
)

INSERT INTO RentalOrders VALUES
(2, 2, 2, 50, 1000, 2221, CONVERT(datetime, '01-01-2019', 104), CONVERT(datetime, '31-01-2019', 104), 1000, 5, 'Rented', NULL),
(3, 1, 1, 10, 4999, 5555, CONVERT(datetime, '01-07-2019', 104), CONVERT(datetime, '15-07-2019', 104), 20, 4.5, 'BOOKED', NULL),
(1, 3, 3, 5, 20543, 21143, CONVERT(datetime, '21-01-2019', 104), CONVERT(datetime, '06-02-2019', 104), 100, 3.3, 'Rented', NULL)

SELECT * FROM RentalOrders 