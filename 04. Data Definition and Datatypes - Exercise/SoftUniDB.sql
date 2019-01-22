-- SoftUni Database
-- 16 Create SoftUni Database

CREATE DATABASE SoftUni
GO
USE SoftUni

-- DROP TABLE Towns   
CREATE TABLE Towns  
(
	Id INT IDENTITY,
	Name NVARCHAR(30) NOT NULL,
	CONSTRAINT PK_Towns PRIMARY KEY (Id)
)

-- DROP TABLE Addresses    
CREATE TABLE Addresses  
(
	Id INT IDENTITY,
	AddressText NVARCHAR(70) NOT NULL,
	TownId INT NOT NULL,
	CONSTRAINT PK_Addresses PRIMARY KEY (Id),
	CONSTRAINT FK_Towns FOREIGN KEY (TownId) REFERENCES Towns (Id)
)

-- DROP TABLE Departments    
CREATE TABLE Departments  
(
	Id INT IDENTITY,
	Name NVARCHAR(50) NOT NULL,
	CONSTRAINT PK_Departments PRIMARY KEY (Id)
)

-- DROP TABLE Employees  
CREATE TABLE Employees  
(
	Id INT IDENTITY,
	FirstName NVARCHAR(30) NOT NULL, 
	MiddleName NVARCHAR(30), 
	LastName NVARCHAR(30) NOT NULL,
	--Name AS CONCAT(FirstName, ' ', MiddleName, ' ', LastName), 
	JobTitle NVARCHAR(35) NOT NULL, 
	DepartmentId INT NOT NULL,
	HireDate DATE NOT NULL, 
	Salary DECIMAL(8, 2) NOT NULL, 
	AddressId INT,
	CONSTRAINT PK_Employees PRIMARY KEY (Id),
	CONSTRAINT FK_Department FOREIGN KEY (DepartmentId) REFERENCES Departments (Id),
	CONSTRAINT FK_Address FOREIGN KEY (AddressId) REFERENCES Addresses (Id),
	CONSTRAINT CHK_Salary CHECK (Salary > 0)
)


-- 17 Backup Database

BACKUP DATABASE SoftUni
TO DISK = 'D:\softuni-backup.bak'


-- 18 Basic Insert

INSERT INTO Towns VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas')

INSERT INTO Departments VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance')

INSERT INTO Employees (FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary) 
VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer',  4, CONVERT([datetime], '01-02-2013',103), 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer',  1, CONVERT([datetime], '02-03-2004',103), 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern',  5, CONVERT([datetime], '28-08-2016',103), 525.25),
('Georgi', 'Teziev', 'Ivanov', 'CEO',  2, CONVERT([datetime], '09-12-2007',103), 3000.00),
('Peter', 'Pan', 'Pan', 'Intern',  3, CONVERT([datetime], '28-08-2016',103), 599.88)


-- 19 Basic Select All Fields

SELECT * FROM Towns  

SELECT * FROM Departments 

SELECT * FROM Employees 


-- 20 Basic Select All Fields and Order Them

SELECT * FROM Towns 
ORDER BY Name -- ASC -- By Default

SELECT * FROM Departments
ORDER BY Name ASC

SELECT * FROM Employees
ORDER BY Salary DESC


-- 21 Basic Select Some Fields

SELECT Name FROM Towns 
ORDER BY Name

SELECT Name FROM Departments
ORDER BY Name ASC

SELECT FirstName, LastName, JobTitle, Salary FROM Employees
ORDER BY Salary DESC


-- 22 Increase Employees Salary

UPDATE Employees SET Salary *= 1.1
SELECT Salary FROM Employees
