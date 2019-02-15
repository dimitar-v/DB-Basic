-- Part 1. Queries for Bank Database
USE Bank

-- Problem 14. Create Table Logs
CREATE TABLE Logs
(
	LogId INT PRIMARY KEY IDENTITY
	, AccountId INT FOREIGN KEY REFERENCES Accounts(ID)
	, OldSum DECIMAL(18,2)
	, NewSum DECIMAL(18,2)
)

SELECT *
FROM Logs

-- Judge 
-- 
CREATE TRIGGER tr_InsertBalanceChanges ON Accounts FOR UPDATE
AS
DECLARE @id INT = (SELECT Id FROM deleted)
DECLARE @oldSum DECIMAL(18,2) = (SELECT Balance FROM deleted)
DECLARE @newSum DECIMAL(18,2) = (SELECT Balance FROM inserted)

INSERT INTO Logs VALUES (@id, @oldSum, @newSum)
-- 

SELECT *
FROM Accounts
WHERE id = 7

UPDATE Accounts
SET Balance -= 10
WHERE Id = 7

-- Problem 15. Create Table Emails
CREATE TABLE NotificationEmails
(
	Id INT PRIMARY KEY IDENTITY
	, Recipient INT FOREIGN KEY REFERENCES Accounts(Id)
	, [Subject] NVARCHAR(50)
	, Body NVARCHAR(500)
)

SELECT *
FROM NotificationEmails

--
CREATE TRIGGER tr_InsertEmailOnNewLog ON Logs FOR INSERT
AS
DECLARE @id INT = (SELECT AccountId FROM inserted)
DECLARE @oldSum DECIMAL(18,2) = (SELECT OldSum FROM inserted)
DECLARE @newSum DECIMAL(18,2) = (SELECT NewSum FROM inserted)

INSERT INTO NotificationEmails VALUES 
( 
	@id
	, 'Balance change for account: ' + CAST(@id AS varchar(10))
	, 'On ' + CONVERT(varchar(25), GETDATE(), 100) + ' your balance was changed from ' + CAST(@oldSum AS varchar(20)) + ' to ' + CAST(@newSum AS varchar(20)) + '.'
)
-- 

UPDATE Accounts
SET Balance += 10
WHERE Id = 1

-- Problem 16. Deposit Money
CREATE PROC usp_DepositMoney (@AccountId INT, @MoneyAmount DECIMAL(18,4))
AS
	DECLARE @Id INT = (SELECT TOP 1  Id FROM Accounts WHERE Id = @AccountId)
	DECLARE @Money DECIMAL(18,4) = IIF( @MoneyAmount > 0, @MoneyAmount, NULL)

	BEGIN TRANSACTION
		UPDATE Accounts
		SET Balance += @Money
		WHERE Id = @Id

	IF(@Id IS NOT NULL AND @Money IS NOT NULL)
		BEGIN
			COMMIT
			RETURN
		END

	ROLLBACK

--
SELECT * FROM Accounts
SELECT * FROM Logs
SELECT * FROM NotificationEmails

EXEC dbo.usp_DepositMoney 1, 6.23

-- Problem 17. Withdraw Money
CREATE PROC usp_WithdrawMoney (@AccountId INT, @MoneyAmount DECIMAL(18,4))
AS
	DECLARE @Id INT = (SELECT TOP 1  Id FROM Accounts WHERE Id = @AccountId)
	DECLARE @Money DECIMAL(18,4) = (SELECT TOP 1  Balance FROM Accounts WHERE Id = @AccountId) - @MoneyAmount
	

	BEGIN TRANSACTION
		UPDATE Accounts
		SET Balance -= @MoneyAmount
		WHERE Id = @Id

	IF(@Id IS NOT NULL AND @Money >= 0 AND @MoneyAmount > 0)
		BEGIN
			COMMIT
			RETURN
		END

	ROLLBACK

--
SELECT * FROM Accounts
SELECT * FROM Logs
SELECT * FROM NotificationEmails

EXEC dbo.usp_WithdrawMoney 1, 6.23

-- Problem 18. Money Transfer
CREATE PROC usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount DECIMAL(18,4))
AS	
	BEGIN TRY
		BEGIN TRANSACTION
		EXEC dbo.usp_WithdrawMoney @SenderID, @Amount
		EXEC dbo.usp_DepositMoney @ReceiverId, @Amount
		COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK
	END CATCH


EXEC dbo.usp_TransferMoney 1, 2, 2200