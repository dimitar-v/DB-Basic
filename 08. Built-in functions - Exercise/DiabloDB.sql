-- Queries for Diablo Database
USE Diablo

-- Problem 14.	Games from 2011 and 2012 year
SELECT TOP(50) [Name], FORMAT(Start, 'yyyy-MM-dd') AS [Start]
FROM Games
WHERE YEAR(Start) BETWEEN 2011 AND 2012
ORDER BY [Start], [Name]

-- Problem 15.	 User Email Providers
SELECT Username, STUFF(Email, 1, CHARINDEX('@', Email), '') AS [Email Provider]
FROM Users
ORDER BY [Email Provider], Username
 
-- Problem 16.	 Get Users with IPAdress Like Pattern
SELECT Username, IpAddress AS [IP Address]
FROM Users
WHERE IpAddress LIKE '___.1_%._%.___'
--WHERE IpAddress LIKE '___.1%.%.___' -- ? 123.1..123 
ORDER BY Username

-- Problem 17.	 Show All Games with Duration and Part of the Day
SELECT [Name]
	, CASE
		WHEN DATEPART(HOUR,[Start]) < 12 THEN 'Morning'
		WHEN DATEPART(HOUR,[Start]) < 18 THEN 'Afternoon'
		WHEN DATEPART(HOUR,[Start]) < 24 THEN 'Evening'
	END 
		AS [Part of the Day]
	--, Duration
	, CASE
		WHEN Duration < 4 THEN 'Extra Short'
		WHEN Duration < 7 THEN 'Short'
		WHEN Duration > 6 THEN 'Long'
		ELSE 'Extra Long '
	END
		AS Duration
FROM Games
ORDER BY [Name], [Duration], [Part of the Day]