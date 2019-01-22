-- 07 Create Table People

CREATE TABLE People
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(200) NOT NULL,
	Picture VARBINARY(MAX),
	Height DECIMAL(3, 2),
	Weight DECIMAL(5, 2),
	Gender CHAR(1) NOT NULL,
	Birthdate DATE NOT NULL,
	Biography NVARCHAR(MAX),
	CONSTRAINT CHK_Picture_Size CHECK (DATALENGTH(Picture) <= 2 * 1024 * 1024),
	CONSTRAINT CHK_Gender CHECK (Gender = 'm' OR Gender = 'f')
)

INSERT INTO People VALUES
('Gosho', NULL, 1.39, 32.15, 'm', '2010/01/21', NULL),
('Pesho', NULL, 1.82, 83, 'm', '1980/01/01', 'Hi!' ),
('Ivan', NULL, 2, 100, 'm', '1999/11/21', '’а сега де!' ),
('Maria', NULL, 1.72, 53, 'f', '1990/05/17', NULL ),
('Dora', NULL, 1.688, 61.98, 'f', '2001/06/22', 'No' )

SELECT * FROM People

TRUNCATE TABLE People


-- 08 Create Table Users

CREATE TABLE Users
(
	Id BIGINT PRIMARY KEY IDENTITY,
	Username VARCHAR(30) UNIQUE NOT NULL,
	Password VARCHAR(26) NOT NULL,
	ProfilePicture VARBINARY(MAX),
	LastLoginTime SMALLDATETIME,
	IsDelited BIT NOT NULL,
	CONSTRAINT CHK_ProfilePicture_Size CHECK (DATALENGTH(ProfilePicture) <= 9 * 1024)
)

INSERT INTO Users VALUES
('asen1234', 'IAmGod', NULL, '2010/01/21 18:45:15', 0),
('admin', 'Admina', NULL, NULL, 0),
('dragon999', 'HaSegaDe', NULL, '1901/07/13 21:01:36', 1),
('loshMC', 'DJ123', NULL, '2052/12/31 23:59:59', 1),
('sssssssssss', 'sssss', NULL, '2000/01/01 00:00:00', 0)

SELECT * FROM Users

TRUNCATE TABLE Users


-- 09 Change Primary Key

ALTER TABLE Users
DROP CONSTRAINT PK__Users__3214EC0769C76E6A

ALTER TABLE Users
ADD CONSTRAINT PK_IdAndUsername 
PRIMARY KEY (Id, Username)


-- 10 Add Check Constraint

ALTER TABLE Users
ADD CONSTRAINT CHK_PasswordMin5
CHECK (DATALENGTH(Password) >= 5)
-- CHECK (LEN([Password]) >= 5)


-- 11 Set Default Value of a Field

ALTER TABLE Users
ADD CONSTRAINT DF_LastLogin DEFAULT GETDATE() FOR LastLoginTime

INSERT INTO Users(Username, Password, ProfilePicture, IsDelited) VALUES
('admin1', 'Admina1', NULL, 0)


-- 12 Set Unique Field

ALTER TABLE Users
DROP CONSTRAINT [PK_IdAndUsername]

ALTER TABLE Users
ADD CONSTRAINT PK_Id
PRIMARY KEY (Id)

ALTER TABLE Users
ADD CONSTRAINT CHK_UsernameMin3
CHECK (LEN(Username) >= 3)
