-- Table Relations
CREATE DATABASE Relations
GO
USE Relations

-- Problem 1.	One-To-One Relationship

CREATE TABLE Passports
(
	PassportID INT UNIQUE,
	PassportNumber VARCHAR(10) NOT NULL UNIQUE,
	CONSTRAINT PK_Passports PRIMARY KEY (PassportID)
)

--DROP TABLE Passports

INSERT INTO Passports VALUES
(101, 'N34FG21B'),
(102, 'K65LO4R7'),
(103, 'ZE657QP2')

CREATE TABLE Persons
(
	PersonID INT IDENTITY,
	FirstName VARCHAR(15) NOT NULL,
	Salary DECIMAL(15, 2),
	PassportID INT NOT NULL UNIQUE,
	CONSTRAINT PK_Persons PRIMARY KEY (PersonID),
	CONSTRAINT FK_Person_Passports FOREIGN KEY (PassportID) REFERENCES Passports(PassportID) 
)

INSERT INTO Persons VALUES
('Roberto',	43300.00,	102),
('Tom', 56100.00,	103),
('Yana', 60200.00,	101)


-- Problem 2.	One-To-Many Relationship

CREATE TABLE Manufacturers
(
	ManufacturerID INT IDENTITY,
	Name VARCHAR(20) NOT NULL,
	EstablishedOn DATE NOT NULL,

	CONSTRAINT PK_Manufacturers 
		PRIMARY KEY (ManufacturerID)
)

CREATE TABLE Models
(
	ModelID INT IDENTITY(101, 1),
	Name VARCHAR(20) NOT NULL,
	ManufacturerID INT NOT NULL,

	CONSTRAINT PK_Models 
		PRIMARY KEY (ModelID),
	CONSTRAINT FK_Models_Manufacturers 
		FOREIGN KEY (ManufacturerID) 
			REFERENCES Manufacturers(ManufacturerID)
)

INSERT INTO Manufacturers
VALUES
	('BMW',		'07/03/1916'),
	('Tesla',	'01/01/2003'),
	('Lada',	'01/05/1966')

INSERT INTO Models
VALUES
	('X1',		1),
	('i6',		1),
	('Model S',	2),
	('Model X',	2),
	('Model 3',	2),
	('Nova',	3)

--SELECT ModelID, Models.Name, m.Name, EstablishedOn
--FROM Models
--	JOIN Manufacturers AS m ON m.ManufacturerID = Models.ManufacturerID 


-- Problem 3.	Many-To-Many Relationship

CREATE TABLE Students
(
	StudentID INT IDENTITY PRIMARY KEY,
	Name VARCHAR(20) NOT NULL
)

CREATE TABLE Exams
(
	ExamsID INT IDENTITY(101, 1) PRIMARY KEY,
	Name VARCHAR(20) NOT NULL
)

CREATE TABLE StudentsExams
(
	StudentID INT NOT NULL,
	ExamID INT NOT NULL,
	
	CONSTRAINT PK_StudentsExams
		PRIMARY KEY (StudentID, ExamID)
)

ALTER TABLE StudentsExams
ADD CONSTRAINT FK_StudentsExams_Students
		FOREIGN KEY (StudentID) 
			REFERENCES Students(StudentID),
	CONSTRAINT FK_StudentsExams_Exams
		FOREIGN KEY (ExamID) 
			REFERENCES Exams(ExamsID)

INSERT INTO Students
VALUES
	('Mila'),                                    
	('Toni'),
	('Ron')

INSERT INTO Exams
VALUES
	('SpringMVC'),
	('Neo4j'),
	('Oracle 11g')

INSERT INTO StudentsExams
VALUES
	(1,	101),
	(1,	102),
	(2,	101),
	(3,	103),
	(2,	102),
	(2,	103)


-- Problem 4.	Self-Referencing 

CREATE TABLE Teachers
(
	TeacherID INT IDENTITY(101, 1) PRIMARY KEY,
	Name VARCHAR(20) NOT NULL,
	ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers
VALUES
	('John',	NULL),
	('Maya',	106	),
	('Silvia',	106	),
	('Ted',		105	),
	('Mark',	101	),
	('Greta',	101	)
