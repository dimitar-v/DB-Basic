-- Section I. Functions and Procedures
-- Part 1. Queries for SoftUni Database

USE SoftUni

-- Problem 1. Employees with Salary Above 35000
CREATE PROC usp_GetEmployeesSalaryAbove35000 
AS
	SELECT FirstName, LastName
	FROM Employees
	WHERE Salary > 35000

EXEC usp_GetEmployeesSalaryAbove35000

-- Problem 2. Employees with Salary Above Number
CREATE PROC usp_GetEmployeesSalaryAboveNumber @Salary DECIMAL(18,4)
AS
	SELECT FirstName, LastName
	FROM Employees
	WHERE Salary >= @Salary

EXEC usp_GetEmployeesSalaryAboveNumber 35000

-- Problem 3. Town Names Starting With
CREATE PROC usp_GetTownsStartingWith @Str VARCHAR(50)
AS
	SET @Str += '%'
	SELECT [Name]
	FROM Towns
	WHERE [Name] LIKE @Str
	-- WHERE [Name] LIKE @Str + '%'
	-- WHERE LEFT(t.[Name], LEN(@Str)) = @Str

EXEC usp_GetTownsStartingWith 'b'

-- Problem 4. Employees from Town
CREATE PROC usp_GetEmployeesFromTown @Town VARCHAR(50)
AS
	SELECT e.FirstName, e.LastName
	FROM Employees AS e
		JOIN Addresses AS a ON e.AddressID = a.AddressID
		JOIN Towns AS t ON a.TownID = t.TownID
	WHERE t.[Name] = @Town

EXEC usp_GetEmployeesFromTown 'Sofia'

-- Problem 5. Salary Level Function
CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4)) 
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @result VARCHAR(10)
	IF(@salary < 30000)
		SET @result = 'Low'
	ELSE IF(@salary > 50000)
		SET @result = 'High'
	ELSE 
		SET @result = 'Average'

	RETURN @result
END

-- 
CREATE OR ALTER FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4)) 
RETURNS VARCHAR(10)
AS
BEGIN
	IF(@salary < 30000)
		RETURN 'Low'
	ELSE IF(@salary > 50000)
		RETURN 'High'

		RETURN 'Average'
END

SELECT Salary, dbo.ufn_GetSalaryLevel(Salary) AS [Salary Level]
FROM Employees

-- Problem 6. Employees by Salary Level
CREATE PROC usp_EmployeesBySalaryLevel @Level VARCHAR(10)
AS
	SELECT FirstName AS [First Name], LastName AS [Last Name]
	FROM Employees
	WHERE dbo.ufn_GetSalaryLevel(Salary) = @Level

EXEC usp_EmployeesBySalaryLevel 'High'

-- Problem 7. Define Function
CREATE  FUNCTION ufn_IsWordComprised(@setOfLetters NVARCHAR(50), @word NVARCHAR(50))
RETURNS BIT  
BEGIN
	DECLARE @index SMALLINT = 1

	WHILE (LEN(@word) >= @index)
	BEGIN
		IF(CHARINDEX(SUBSTRING(@word, @index, 1), @setOfLetters) = 0)
			RETURN 0

		SET @index += 1
	END

	RETURN 1

END

SELECT dbo.ufn_IsWordComprised('pppp','Guy')

-- Problem 8. * Delete Employees and Departments
CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT) 
AS

	-- 1. Alter table Departments column ManagerID to nullable 
	ALTER TABLE Departments
	ALTER COLUMN ManagerID INT
	
	-- 2. Update Departments set ManagerID to NULL
	UPDATE Departments
	SET ManagerID = NULL
	WHERE DepartmentID = @departmentId

	-- 3. Delete from EmployeesProjects 
	DELETE FROM EmployeesProjects
	WHERE EmployeeID IN (
		SELECT EmployeeID
		FROM Employees
		WHERE DepartmentID = @departmentId
	)

	-- 4. Set emploees ManagerID to NULL where manager is from @departmentId
	UPDATE Employees
	SET ManagerID = NULL
	WHERE ManagerID IN (
		SELECT EmployeeID
		FROM Employees
		WHERE DepartmentID = @departmentId
	)

	-- 5. Set departments ManagerID to NULL where manager is from @departmentId
	UPDATE Departments
	SET ManagerID = NULL
	WHERE ManagerID IN (
		SELECT EmployeeID
		FROM Employees
		WHERE DepartmentID = @departmentId
	)

	-- 6. Delete from Employees where @departmentId
	DELETE FROM Employees
	WHERE DepartmentID = @departmentId
	
	-- 7. Delete from Departments @departmentId
	DELETE FROM Departments
	WHERE DepartmentID = @departmentId
	
	-- Check count of employee with @departmentId
	SELECT COUNT(EmployeeID) AS [Employees Count]
	FROM Employees
	WHERE DepartmentID = @departmentId
	
--
	EXEC usp_DeleteEmployeesFromDepartment 3