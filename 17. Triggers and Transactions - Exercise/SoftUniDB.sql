-- Part 3. Queries for SoftUni Database
USE SoftUni

-- Problem 21. Employees with Three Projects
CREATE PROC usp_AssignProject(@emloyeeId INT, @projectID INT)
AS
	BEGIN TRANSACTION
	
	DECLARE @employee INT = (SELECT EmployeeID FROM Employees WHERE EmployeeID = @emloyeeId) 
	DECLARE @peoject INT = (SELECT ProjectID FROM Projects WHERE ProjectID = @projectID) 

	IF(@employee IS NULL OR @peoject IS NULL)
	BEGIN
		ROLLBACK 
		RAISERROR('Invalid parametars', 16, 2)
		RETURN
	END

	DECLARE @totalProjects INT = (SELECT COUNT(ProjectID) FROM EmployeesProjects WHERE EmployeeID = @emloyeeId)

	IF(@totalProjects >= 3)
	BEGIN
		ROLLBACK 
		RAISERROR('The employee has too many projects!', 16, 1)
		RETURN
	END

	INSERT INTO EmployeesProjects (EmployeeID, ProjectID)
	VALUES (@emloyeeId, @projectID)

	COMMIT

	--
	SELECT * FROM EmployeesProjects WHERE EmployeeID = 1

	EXEC usp_AssignProject 1, 8

	SELECT * FROM EmployeesProjects WHERE EmployeeID = 2

	EXEC usp_AssignProject 2, 8


-- Problem 22. Delete Employees
CREATE TABLE Deleted_Employees
(
	EmployeeId INT PRIMARY KEY IDENTITY
	, FirstName NVARCHAR(50)
	, LastName NVARCHAR(50)
	, MiddleName NVARCHAR(50)
	, JobTitle NVARCHAR(50)
	, DepartmentId INT
	, Salary DECIMAL(18, 2)
) 
GO
--
CREATE TRIGGER tr_DeleteEmployee ON Employees AFTER DELETE
AS
	INSERT INTO Deleted_Employees (FirstName, LastName, MiddleName, JobTitle, DepartmentId, Salary)
	SELECT FirstName, LastName, MiddleName, JobTitle, DepartmentID, Salary FROM deleted