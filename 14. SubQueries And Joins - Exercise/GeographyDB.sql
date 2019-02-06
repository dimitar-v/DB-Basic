-- Geography DataBase
USE Geography

-- Problem 12.	Highest Peaks in Bulgaria
SELECT        MountainsCountries.CountryCode, Mountains.MountainRange, Peaks.PeakName, Peaks.Elevation
FROM            MountainsCountries 
				INNER JOIN
                         Mountains ON MountainsCountries.MountainId = Mountains.Id 
				INNER JOIN
                         Peaks ON Mountains.Id = Peaks.MountainId
WHERE CountryCode = 'BG' AND Elevation > 2835
ORDER BY Elevation DESC

-- Problem 13.	Count Mountain Ranges
SELECT        MountainsCountries.CountryCode, COUNT(MountainsCountries.MountainId) AS MountainRanges
FROM            MountainsCountries 
				INNER JOIN
                         Countries ON MountainsCountries.CountryCode = Countries.CountryCode
WHERE Countries.CountryName IN ('United States', 'Russia', 'Bulgaria')
GROUP BY MountainsCountries.CountryCode

--
SELECT CountryCode, COUNT(MountainId) AS MountainRanges
FROM MountainsCountries
WHERE CountryCode IN ('US', 'RU', 'BG')
GROUP BY CountryCode

-- Problem 14.	Countries with Rivers
SELECT       TOP (5) Countries.CountryName, Rivers.RiverName
FROM            Continents 
				INNER JOIN
                         Countries ON Continents.ContinentCode = Countries.ContinentCode 
				LEFT JOIN
                         CountriesRivers ON Countries.CountryCode = CountriesRivers.CountryCode 
				LEFT JOIN
                         Rivers ON CountriesRivers.RiverId = Rivers.Id
WHERE ContinentName = 'Africa'
ORDER BY CountryName

-- Problem 15.	*Continents and Currencies
SELECT ContinentCode, CurrencyCode, CurrancyUsage
FROM 
(
	SELECT 
		ContinentCode
		, CurrencyCode
		, COUNT(CurrencyCode) AS CurrancyUsage
		, DENSE_RANK() OVER 
		(
			PARTITION BY ContinentCode 
			ORDER BY COUNT(CurrencyCode) DESC
		) AS DenseRank  
	FROM Countries
	GROUP BY ContinentCode, CurrencyCode
	--HAVING COUNT(CurrencyCode) > 1
) AS CurrancyUsege
WHERE DenseRank = 1 AND CurrancyUsage > 1
ORDER BY ContinentCode

-- Problem 16.	Countries without any Mountains
SELECT COUNT(c.CountryCode) AS CountryCode
FROM MountainsCountries AS mc
	RIGHT JOIN Countries AS c ON mc.CountryCode = c.CountryCode
WHERE MountainId IS NULL
GROUP BY mc.CountryCode

-- Problem 17.	Highest Peak and Longest River by Country
SELECT   TOP (5) CountryName
			, Elevation AS HighestPeakElevation
			, Length AS LongestRiverLength
FROM
(
	SELECT  Countries.CountryName
			, Peaks.Elevation
			, Rivers.Length
			, DENSE_RANK() OVER (PARTITION BY Countries.CountryName ORDER BY Peaks.Elevation DESC, Rivers.Length DESC) AS DenseRank    
	FROM Countries 
				LEFT JOIN
                         CountriesRivers ON Countries.CountryCode = CountriesRivers.CountryCode 
				LEFT JOIN
                         Rivers ON CountriesRivers.RiverId = Rivers.Id
				LEFT JOIN
                         MountainsCountries ON Countries.CountryCode = MountainsCountries.CountryCode
				LEFT JOIN
                         Mountains ON MountainsCountries.MountainId = Mountains.Id 
				LEFT JOIN
                         Peaks ON Mountains.Id = Peaks.MountainId
) AS RankPeakAndRiver
WHERE DenseRank = 1
ORDER BY Elevation DESC, Length DESC

--
SELECT TOP(5) Countries.CountryName
			, MAX (Peaks.Elevation) AS HighestPeakElevation
			, MAX (Rivers.Length) AS LongestRiverLength 
FROM Countries 
				LEFT JOIN
                         CountriesRivers ON Countries.CountryCode = CountriesRivers.CountryCode 
				LEFT JOIN
                         Rivers ON CountriesRivers.RiverId = Rivers.Id
				LEFT JOIN
                         MountainsCountries ON Countries.CountryCode = MountainsCountries.CountryCode
				LEFT JOIN
                         Mountains ON MountainsCountries.MountainId = Mountains.Id 
				LEFT JOIN
                         Peaks ON Mountains.Id = Peaks.MountainId
GROUP BY Countries.CountryName
ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC

-- Problem 18.	* Highest Peak Name and Elevation by Country
SELECT TOP(5) CountryName, [Highest Peak Name], [Highest Peak Elevation], Mountain
FROM
(
	SELECT        Countries.CountryName
				, ISNULL(Peaks.PeakName, '(no highest peak)') AS [Highest Peak Name]
				, ISNULL(MAX(Peaks.Elevation), 0) AS [Highest Peak Elevation]
				, ISNULL(Mountains.MountainRange, '(no mountain)') AS [Mountain]
				, DENSE_RANK() OVER (PARTITION BY Countries.CountryName ORDER BY Peaks.Elevation DESC) AS DenseRank    
	FROM            Countries 
					LEFT JOIN
							 MountainsCountries ON Countries.CountryCode = MountainsCountries.CountryCode 
					LEFT JOIN
							 Mountains ON MountainsCountries.MountainId = Mountains.Id 
					LEFT JOIN
							 Peaks ON Mountains.Id = Peaks.MountainId
) AS hp
WHERE DenseRank = 1
ORDER BY CountryName, [Highest Peak Name]

-- 
WITH CTE_AllCountriesInfo(CountryName, [Highest Peak Name], [Highest Peak Elevation], Mountain, DenseRank) AS 
(
	SELECT 
		c.CountryName,
		ISNULL(p.PeakName, '(no highest peak)'),
		ISNULL(p.Elevation, 0), 
		ISNULL(m.MountainRange, '(no mountain)'),
		DENSE_RANK() OVER (PARTITION BY c.CountryName ORDER BY p.Elevation DESC)
	FROM Countries AS c
	LEFT OUTER JOIN MountainsCountries AS mc
		ON mc.CountryCode = c.CountryCode
	LEFT OUTER JOIN Peaks AS p
		ON p.MountainId = mc.MountainId
	LEFT OUTER JOIN Mountains AS m
		ON m.Id = mc.MountainId
)

SELECT TOP(5)
   CountryName, [Highest Peak Name], [Highest Peak Elevation], Mountain
FROM CTE_AllCountriesInfo
WHERE DenseRank = 1
ORDER BY CountryName, [Highest Peak Name]