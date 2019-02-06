-- SoftUni Database
USE SoftUni

-- Problem 1.	Employee Address
SELECT TOP(5) e.EmployeeID, e.JobTitle, e.AddressID, a.AddressText 
FROM Employees AS e
	JOIN Addresses AS a ON e.AddressID = a.AddressID
ORDER BY AddressID

-- Problem 2.	Addresses with Towns
SELECT TOP(50) e.FirstName, e.LastName, t.[Name] AS Town, a.AddressText 
FROM Employees AS e
	JOIN Addresses AS a ON e.AddressID = a.AddressID
	JOIN Towns AS t ON a.TownID = t.TownID
ORDER BY e.FirstName, e.LastName

-- Problem 3.	Sales Employee
SELECT e.EmployeeID, e.FirstName, e.LastName, d.[Name] AS DepartmentName
FROM Employees AS e
	JOIN Departments AS d ON e.DepartmentID = d.DepartmentID AND d.[Name] IN ('Sales')
ORDER BY EmployeeID

-- Problem 4.	Employee Departments
SELECT        TOP(5) Employees.EmployeeID, Employees.FirstName, Employees.Salary, Departments.Name AS DepartmentName
FROM            Employees 
				INNER JOIN
                         Departments ON Employees.DepartmentID = Departments.DepartmentID AND Salary > 15000
ORDER BY Departments.DepartmentID

-- Problem 5.	Employees Without Project
SELECT       TOP(3) Employees.EmployeeID, Employees.FirstName
FROM            Employees 
				LEFT JOIN
                         EmployeesProjects ON Employees.EmployeeID = EmployeesProjects.EmployeeID 
WHERE EmployeesProjects.ProjectID IS NULL
ORDER BY Employees.EmployeeID

--
SELECT TOP (3) EmployeeID, FirstName
FROM Employees AS e
WHERE EmployeeID NOT IN (SELECT EmployeeID FROM EmployeesProjects)


-- Problem 6.	Employees Hired After
SELECT        Employees.FirstName, Employees.LastName, Employees.HireDate, Departments.Name AS DeptName
FROM            Employees 
				INNER JOIN
                         Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE HireDate > '1999-01-01' AND Name IN ('Sales', 'Finance')
ORDER BY HireDate

-- Problem 7.	Employees with Project
SELECT       TOP(5) Employees.EmployeeID, Employees.FirstName, Projects.Name AS ProjectName
FROM            Employees 
				INNER JOIN
                         EmployeesProjects ON Employees.EmployeeID = EmployeesProjects.EmployeeID 
				INNER JOIN
                         Projects ON EmployeesProjects.ProjectID = Projects.ProjectID
WHERE Projects.StartDate > '2002-08-13' AND Projects.EndDate IS NULL
ORDER BY Employees.EmployeeID

-- Problem 8.	Employee 24
SELECT        Employees.EmployeeID, Employees.FirstName, 
				CASE
					WHEN YEAR(Projects.StartDate) >= 2005 THEN NULL
					ELSE Projects.Name 
				END AS ProjectName
FROM            Employees 
				INNER JOIN 
                         EmployeesProjects ON Employees.EmployeeID = EmployeesProjects.EmployeeID 
				INNER JOIN
                         Projects ON EmployeesProjects.ProjectID = Projects.ProjectID
WHERE Employees.EmployeeID = 24 

--
SELECT        Employees.EmployeeID, Employees.FirstName, 
				IIF( YEAR(Projects.StartDate) >= 2005,  NULL, Projects.Name) AS ProjectName
FROM            Employees 
				INNER JOIN 
                         EmployeesProjects ON Employees.EmployeeID = EmployeesProjects.EmployeeID 
				INNER JOIN
                         Projects ON EmployeesProjects.ProjectID = Projects.ProjectID
WHERE Employees.EmployeeID = 24 

-- Problem 9.	Employee Manager
SELECT        Employees.EmployeeID, Employees.FirstName, Employees_1.EmployeeID AS ManagerID, Employees_1.FirstName AS ManagerName
FROM            Employees 
				INNER JOIN
                         Employees AS Employees_1 ON Employees.ManagerID = Employees_1.EmployeeID
WHERE Employees_1.EmployeeID IN (3, 7)
ORDER BY EmployeeID

--
SELECT e.EmployeeID, e.FirstName, e.ManagerID, m.FirstName AS ManagerName
FROM Employees AS e
	JOIN Employees AS m ON e.ManagerID = m.EmployeeID
WHERE e.ManagerID IN (3, 7)
ORDER BY EmployeeID

-- Problem 10.	Employee Summary
SELECT       TOP(50) Employees.EmployeeID
			, CONCAT(Employees.FirstName, ' ', Employees.LastName) AS EmployeeName
			, CONCAT(Employees_1.FirstName, ' ', Employees_1.LastName) AS ManagerName
			, Departments.Name AS DepartmentName
FROM            Employees 
				INNER JOIN
                         Employees AS Employees_1 ON Employees.ManagerID = Employees_1.EmployeeID 
				INNER JOIN
                         Departments ON Employees.DepartmentID = Departments.DepartmentID 
ORDER BY	EmployeeID

-- Problem 11.	Min Average Salary
SELECT MIN(AvgS) AS MinAverageSalary
FROM 
(
	SELECT AVG(Salary) AS AvgS
	FROM Employees
	GROUP BY DepartmentID
) AS Salary

--
SELECT TOP(1) AVG(Salary) AS MinAverageSalary
FROM Employees
GROUP BY DepartmentID
ORDER BY AVG(Salary)

--
WITH CTE_AvgSalaries(AverageSalary) AS
(
	SELECT AVG(Salary) AS AvgS
	FROM Employees
	GROUP BY DepartmentID
)

SELECT MIN(AverageSalary) AS MinAverageSalary
FROM CTE_AvgSalaries