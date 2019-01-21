-- 01 Create Database
CREATE DATABASE Minions

USE Minions

-- 02 Create Tables
CREATE TABLE Minions
(
	Id INT PRIMARY KEY,
	[Name] NVARCHAR(20) NOT NULL,
	Age INT
)

CREATE TABLE Towns
(
	Id INT PRIMARY KEY,
	[Name] NVARCHAR(25) NOT NULL
)

-- 03 Alter Minions Table
ALTER TABLE dbo.Minions 
ADD TownId INT CONSTRAINT FK_TownId_Towns FOREIGN KEY REFERENCES Towns(Id)

-- 04 Insert Records in Both Tables
INSERT INTO Towns(Id, Name)
VALUES (1, 'Sofia'),
	   (2, 'Plovdiv'),
	   (3, 'Varna')

INSERT INTO Minions(Id, Name, Age, TownId)
VALUES (1, 'Kevin', 22, 1),
	   (2, 'Bob', 15, 3),
	   (3, 'Steward', NULL, 2)

-- 05 Truncate Table Minions
TRUNCATE TABLE Minions

-- 06 Drop All Tables
DROP TABLE Minions
DROP TABLE Towns
