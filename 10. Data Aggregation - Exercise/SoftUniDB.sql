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


-- Problem 16.	Employees Maximum Salaries
SELECT DepartmentID, MAX(Salary) AS MaxSalary
FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

-- Problem 17.	Employees Count Salaries
SELECT COUNT(Salary) AS [Count]
FROM Employees
WHERE ManagerID IS NULL

-- Problem 18.	*3rd Highest Salary -- xxx
SELECT DepartmentID, Salary AS [ThirdHighestSalary]
FROM 
(
    SELECT
		DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS DenseRank
      , DepartmentID 
	  , Salary
    FROM Employees 
	GROUP BY DepartmentID, Salary
) AS os
WHERE DenseRank = 3

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