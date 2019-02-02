-- SoftUni DateBase
USE SoftUni

-- Problem 13.	Departments Total Salaries
SELECT DepartmentID, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

-- Problem 14.	Employees Minimum Salaries
SELECT DepartmentID, MIN(Salary) AS MinimumSalary
FROM Employees
WHERE DepartmentID IN (2,5,7) AND HireDate > '2000-01-01'
GROUP BY DepartmentID

-- Problem 15.	Employees Average Salaries
SELECT *
INTO Table1
FROM Employees
WHERE Salary > 30000

--SELECT *
--FROM Table1

DELETE
FROM Table1
WHERE ManagerID = 42

UPDATE Table1
SET Salary += 5000
WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary) AS AvgSalary
FROM Table1
GROUP BY DepartmentID

-- Problem 16.	Employees Maximum Salaries
SELECT DepartmentID, MAX(Salary) AS MaxSalary
FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

-- Problem 17.	Employees Count Salaries
SELECT COUNT(Salary) AS [Count]
FROM Employees
WHERE ManagerID IS NULL

-- Problem 18.	*3rd Highest Salary
SELECT DepartmentID, Salary AS [ThirdHighestSalary]
FROM 
(
    SELECT
		DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS DenseRank
      , DepartmentID 
	  , Salary
    FROM Employees 
) AS os
WHERE DenseRank = 3
GROUP BY DepartmentID, Salary

-- Problem 19.	**Salary Challenge
SELECT TOP(10) e.FirstName, e.LastName, e.DepartmentID --, e.Salary
FROM 
	Employees AS e
	, (
		SELECT DepartmentID, AVG(Salary) AS AvgSalary
		FROM Employees
		GROUP BY DepartmentID
	) AS a
WHERE e.DepartmentID = a.DepartmentID AND e.Salary > a.AvgSalary
ORDER BY DepartmentID

-- 19
SELECT TOP(10) FirstName, LastName, DepartmentID
FROM Employees AS e
WHERE Salary > (
	SELECT AVG(Salary)
	FROM Employees AS em
	WHERE em.DepartmentID = e.DepartmentID)
ORDER BY DepartmentID