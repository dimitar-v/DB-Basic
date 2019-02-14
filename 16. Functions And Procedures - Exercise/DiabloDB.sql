-- Part 3. Queries for Diablo Database
USE Diablo

-- Problem 13. *Scalar Function: Cash in User Games Odd Rows
CREATE FUNCTION ufn_CashInUsersGames(@GameName VARCHAR(MAX))
RETURNS TABLE
RETURN
(
	SELECT SUM(Cash) AS TotalCash
	FROM
	(
		SELECT        Games.Name, UsersGames.Cash,
						ROW_NUMBER() OVER(ORDER BY Cash desc) AS RowNum
		FROM            Games INNER JOIN
								 UsersGames ON Games.Id = UsersGames.GameId
		WHERE Games.Name = @GameName
	) AS k
	WHERE RowNum % 2 <> 0
)

SELECT *
FROM dbo.ufn_CashInUsersGames('Love in a mist')