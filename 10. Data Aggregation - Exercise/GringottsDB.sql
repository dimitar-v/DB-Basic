-- Gringotts DataBase
USE Gringotts

-- Problem 1.	Records’ Count
SELECT COUNT(Id) AS [Count]
FROM WizzardDeposits

-- Problem 2.	Longest Magic Wand
SELECT MAX(MagicWandSize) AS [Longest Magic Wand]
FROM WizzardDeposits

-- Problem 3.	Longest Magic Wand per Deposit Groups
SELECT DepositGroup, MAX(MagicWandSize) AS [Longest Magic Wand]
FROM WizzardDeposits
GROUP BY DepositGroup

-- Problem 4.	* Smallest Deposit Group per Magic Wand Size
SELECT TOP(2) DepositGroup
FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize)

-- Problem 5.	Deposits Sum
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
GROUP BY DepositGroup

-- Problem 6.	Deposits Sum for Ollivander Family
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup

-- Problem 7.	Deposits Filter
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY TotalSum DESC

-- Problem 8.	 Deposit Charge
SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) AS MinDepositCharge
FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, DepositGroup

-- Problem 9.	Age Groups
SELECT AgeGroup, COUNT(AgeGroup) AS WizardCount
FROM(
SELECT 
	CASE
		WHEN Age <= 10 THEN '[0-10]'
		WHEN Age <= 20 THEN '[11-20]'
		WHEN Age <= 30 THEN '[21-30]'
		WHEN Age <= 40 THEN '[31-40]'
		WHEN Age <= 50 THEN '[41-50]'
		WHEN Age <= 60 THEN '[51-60]'
		ELSE '[61+]'
	END AS AgeGroup
FROM WizzardDeposits) AS Age
GROUP BY AgeGroup
	
-- Problem 10.	First Letter
SELECT LEFT(FirstName, 1) AS FirstLeter
FROM WizzardDeposits
WHERE DepositGroup = 'Troll Chest'
GROUP BY LEFT(FirstName, 1)
--
SELECT LEFT(FirstName, 1) AS FirstLeter
FROM WizzardDeposits
GROUP BY LEFT(FirstName, 1), DepositGroup
HAVING DepositGroup = 'Troll Chest'

-- Problem 11.	Average Interest 
SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest) AS AerageInterest
--SELECT DepositGroup, IsDepositExpired, FORMAT(AVG(DepositInterest), 'N2') AS AerageInterest -- round two digits
FROM WizzardDeposits
WHERE DepositStartDate > '1985-01-01' 
--WHERE YEAR(DepositStartDate) >= 1985
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired

-- Problem 12.	* Rich Wizard, Poor Wizard
SELECT SUM([Difference]) AS SumDifference
FROM
(
	SELECT 
		FirstName AS [Host Wizard]
		, DepositAmount AS [Host Wizard Deposit]
		, LEAD(FirstName) OVER (ORDER BY Id) AS [Guest Wizard]
		, LEAD(DepositAmount) OVER (ORDER BY Id) AS [Guest Wizard Deposit]
		,  DepositAmount - LEAD(DepositAmount) OVER (ORDER BY Id) AS [Difference]
	FROM WizzardDeposits
) AS td

-- 12
SELECT SUM([Difference]) AS SumDifference
FROM
(
	SELECT DepositAmount - LEAD(DepositAmount) OVER (ORDER BY Id) AS [Difference]
	FROM WizzardDeposits
) AS dt

-- 12
SELECT SUM(d.Diff)
FROM(
	SELECT 
		w.DepositAmount
		- (	SELECT w2.DepositAmount 
			FROM WizzardDeposits AS w2
			WHERE w2.Id = w.Id + 1
			) AS Diff
	FROM WizzardDeposits AS w ) AS d