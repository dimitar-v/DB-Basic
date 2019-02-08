-- Part 2. Queries for Bank Database
USE Bank

-- Problem 9. Find Full Name
CREATE PROC usp_GetHoldersFullName 
AS
	SELECT FirstName + ' ' + LastName AS [Full Name]
	FROM AccountHolders

--
EXEC usp_GetHoldersFullName

-- Problem 10. People with Balance Higher Than
CREATE PROC usp_GetHoldersWithBalanceHigherThan @totalMoney DECIMAL(18,4)
AS
	SELECT ah.FirstName, ah.LastName
	FROM AccountHolders AS ah
		INNER JOIN Accounts AS a ON ah.Id = a.AccountHolderId
	GROUP BY a.AccountHolderId, ah.FirstName, ah.LastName
	HAVING SUM(a.Balance) > @totalMoney
	ORDER BY ah.FirstName, ah.LastName

--
EXEC usp_GetHoldersWithBalanceHigherThan 10000

-- Problem 11. Future Value Function
CREATE FUNCTION ufn_CalculateFutureValue(@sum DECIMAL(18,4), @yearlyInterestRate FLOAT, @years INT)
RETURNS DECIMAL(18,4)
AS
BEGIN
	RETURN @sum * POWER(1 + @yearlyInterestRate, @years)
END
--
SELECT dbo.ufn_CalculateFutureValue(1000, 0.1, 5)
--
SELECT Balance, dbo.ufn_CalculateFutureValue(Balance, 0.1, 5)
FROM Accounts

-- Problem 12. Calculating Interest
CREATE PROC usp_CalculateFutureValueForAccount @accountID INT, @interestReat FLOAT
AS
	SELECT
		 a.Id
		, ah.FirstName
		, ah.LastName
		, a.Balance
		, dbo.ufn_CalculateFutureValue(a.Balance, @interestReat, 5) AS [Balance in 5 years]
	FROM AccountHolders AS ah
		 INNER JOIN Accounts AS a ON ah.Id = a.AccountHolderId
	WHERE a.Id = @accountID

--
EXEC usp_CalculateFutureValueForAccount 1 , 0.1