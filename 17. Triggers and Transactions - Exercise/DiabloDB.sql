-- Part 2. Queries for Diablo Database
USE Diablo

-- Problem 19. Trigger
SELECT *
FROM UsersGames AS ug
	JOIN UserGameItems AS ugi ON ug.Id = ugi.UserGameId
	JOIN Items AS i ON ugi.ItemId = i.Id
-- 1
CREATE TRIGGER tr_RestrictHigerItemLevel ON UserGameItems INSTEAD OF INSERT
AS
	DECLARE @ItemID INT = (SELECT ItemId FROM inserted)
	DECLARE @UserGameID INT = (SELECT UserGameId FROM inserted)

	DECLARE @ItemMinLevel INT = (
		SELECT MinLevel FROM Items WHERE Id = @ItemID)	
	DECLARE @UserLevel INT = (
		SELECT [Level] FROM UsersGames WHERE Id = @UserGameID)

	IF(@UserLevel >= @ItemMinLevel)
	BEGIN
		INSERT INTO UserGameItems (UserGameId, ItemId)
		VALUES (@UserGameID, @ItemID)
	END
	ELSE
		RAISERROR('User can not buy this item!', 16, 1)
--

INSERT INTO UserGameItems (UserGameId, ItemId)
VALUES (79, 2)
-- 22, 46

INSERT INTO UserGameItems (UserGameId, ItemId)
VALUES (79, 14)
-- 22, 17

SELECT *
FROM UserGameItems
WHERE UserGameId = 79

SELECT *
FROM Items

-- 2
UPDATE UsersGames
SET Cash += 50000
FROM UsersGames AS ug
	JOIN Games AS g ON ug.GameId = g.Id
	JOIN Users AS u ON ug.UserId = u.Id
WHERE g.Name = 'Bali' 
	AND u.Username IN ('baleremuda', 'loosenoise', 'inguinalself', 'buildingdeltoid', 'monoxidecos')
	

SELECT *
FROM UsersGames

-- 3
CREATE PROC usp_BuyItems @UserID INT, @ItemID INT, @GameID INT
AS	
	DECLARE @user INT = (SELECT Id FROM Users WHERE Id = @UserID)
	DECLARE @item INT = (SELECT Id FROM Items WHERE Id = @ItemID)
	DECLARE @game INT = (SELECT Id FROM Games WHERE Id = @GameID)

	IF(@user IS NULL OR @item IS NULL OR @game IS NULL)
	BEGIN
		RAISERROR('Invalid input UserId or ItemId or GameId!',16,1)
		RETURN
	END

	DECLARE @userCash DECIMAL(18,2) = (SELECT Cash FROM UsersGames WHERE UserId = @UserID AND GameId = @GameID)
	DECLARE @itemPrice DECIMAL(18,2) = (SELECT Price FROM Items WHERE Id = @ItemID)

	IF (@userCash < @itemPrice)
	BEGIN
		RAISERROR('Not enough Cash!',16,1)
		RETURN
	END

	DECLARE @userGameID INT = (SELECT Id FROM UsersGames WHERE UserId = @UserID AND GameId = @GameID)

	BEGIN TRANSACTION
		INSERT INTO UserGameItems (UserGameId, ItemId)
		VALUES (@userGameID, @ItemID)

		UPDATE UsersGames
		SET Cash -= @itemPrice
		WHERE Id = @userGameID
	COMMIT

--

	SELECT * FROM Games WHERE Name = 'Bali'
	-- Game ID  212

	SELECT * 
	FROM Users AS u
	JOIN UsersGames AS ug ON u.Id = ug.UserId
	WHERE u.Username IN ('baleremuda', 'loosenoise', 'inguinalself', 'buildingdeltoid', 'monoxidecos')
	AND GameId = 212
	-- Users ID  12, 22, 37, 52, 61

	DECLARE @counter1 INT = 251

	WHILE(@counter1 < 300)
	BEGIN
		EXEC usp_BuyItems 12, @counter1, 212 
		EXEC usp_BuyItems 22, @counter1, 212 
		EXEC usp_BuyItems 37, @counter1, 212 
		EXEC usp_BuyItems 52, @counter1, 212 
		EXEC usp_BuyItems 61, @counter1, 212 

		SET @counter1 += 1
	END

	DECLARE @counter2 INT = 501

	WHILE(@counter2 < 540)
	BEGIN
		EXEC usp_BuyItems 12, @counter2, 212 
		EXEC usp_BuyItems 22, @counter2, 212 
		EXEC usp_BuyItems 37, @counter2, 212 
		EXEC usp_BuyItems 52, @counter2, 212 
		EXEC usp_BuyItems 61, @counter2, 212 

		SET @counter2 += 1
	END

-- 4
SELECT u.Username, g.Name AS 'Games Name', ug.Cash, i.Name AS 'Items Name'
FROM UsersGames AS ug
	JOIN Users AS u ON ug.UserId = u.Id
	JOIN Games AS g ON ug.GameId = g.Id
	JOIN UserGameItems AS ugi ON ug.Id = ugi.UserGameId
	JOIN Items AS i ON ugi.ItemId = i.Id
WHERE g.Name = 'Bali'
ORDER BY u.Username, i.Name