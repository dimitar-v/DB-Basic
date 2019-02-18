--Database Basics MSSQL Exam – 17 Feb 2019
--School DB
CREATE DATABASE School
GO
USE School
--Section 1. DDL (30 pts)
CREATE TABLE Students
(
	Id INT PRIMARY KEY IDENTITY
	, FirstName NVARCHAR(30) NOT NULL
	, MiddleName NVARCHAR(25) 
	, LastName NVARCHAR(30) NOT NULL
	, Age INT CHECK (Age >= 5 AND Age <= 100) NOT NULL
	, [Address] NVARCHAR(50) 
	, Phone NCHAR(10) 
)

CREATE TABLE Subjects
(
	Id INT PRIMARY KEY IDENTITY
	, [Name] NVARCHAR(20) NOT NULL
	, Lessons INT CHECK (Lessons > 0) NOT NULL
)

CREATE TABLE StudentsSubjects
(
	Id INT PRIMARY KEY IDENTITY
	, StudentId INT FOREIGN KEY REFERENCES Students(Id) NOT NULL
	, SubjectId INT FOREIGN KEY REFERENCES Subjects(Id) NOT NULL
	, Grade DECIMAL(3,2) CHECK (Grade BETWEEN 2 AND 6) NOT NULL
)

CREATE TABLE Exams
(
	Id INT PRIMARY KEY IDENTITY
	, [Date] DATE 
	, SubjectId INT FOREIGN KEY REFERENCES Subjects(Id) NOT NULL
)

CREATE TABLE StudentsExams
(
	StudentId INT FOREIGN KEY REFERENCES Students(Id) NOT NULL
	, ExamId INT FOREIGN KEY REFERENCES Exams(Id) NOT NULL
	, Grade DECIMAL(3,2) CHECK (Grade BETWEEN 2 AND 6) NOT NULL

	, PRIMARY KEY (StudentId, ExamId)
)

CREATE TABLE Teachers
(
	Id INT PRIMARY KEY IDENTITY
	, FirstName NVARCHAR(20) NOT NULL
	, LastName NVARCHAR(20) NOT NULL
	, [Address] NVARCHAR(20) NOT NULL
	, Phone NCHAR(10) 
	, SubjectId INT FOREIGN KEY REFERENCES Subjects(Id) NOT NULL
)

CREATE TABLE StudentsTeachers
(
	StudentId INT FOREIGN KEY REFERENCES Students(Id) NOT NULL
	, TeacherId INT FOREIGN KEY REFERENCES Teachers(Id) NOT NULL

	, PRIMARY KEY (StudentId, TeacherId)
)

--Students
--Column	Data Type	Constraints
--Id	Integer from 0 to 2,147,483,647	Unique table identificator, Identity
--FirstName	String up to 30 symbols, Unicode	NULL is not allowed
--MiddleName	String up to 25 symbols, Unicode	None
--LastName	String up to 30 symbols, Unicode	NULL is not allowed
--Age	Integer from 5 to 100	Negative or zero numbers are not allowed
--Address	String up to 50 symbols, Unicode	None
--Phone	String with exactly 10 symbols, Unicode	None

--Subjects
--Column	Data Type	Constraints
--Id	Integer from 0 to 2,147,483,647	Unique table identificator, Identity
--Name	String up to 20 symbols, Unicode	NULL is not allowed
--Lessons	Integer must be more than 0	NULL is not allowed

--StudentsSubjects
--Column	Data Type	Constraints
--Id	Integer from 0 to 2,147,483,647	Unique table identificator, Identity
--StudentId	Integer from 0 to 2,147,483,647	NULL is not allowed, Relationship with table Students
--SubjectId	Integer from 0 to 2,147,483,647	NULL is not allowed, Relationship with table Subjects
--Grade	Decimal number with two-digit precision	Grade must be between 2 and 6, NULL is not allowed

--Exams
--Column	Data Type	Constraints
--Id	Integer from 0 to 2,147,483,647	Unique table identificator, Identity
--Date	DateTime	None
--SubjectId	Integer from 0 to 2,147,483,647	NULL is not allowed, Relationship with table Subjects

--StudentsExams
--Column	Data Type	Constraints
--StudentId	Integer from 0 to 2,147,483,647	NULL is not allowed, Relationship with table Students
--ExamId	Integer from 0 to 2,147,483,647	NULL is not allowed, Relationship with table Exams
--Grade	Decimal number with two-digit precision	Grade must be between 2 and 6, NULL is not allowed

--Teachers
--Column	Data Type	Constraints
--Id	Integer from 0 to 2,147,483,647	Unique table identificator, Identity
--FirstName	String up to 20 symbols, Unicode	NULL is not allowed
--LastName	String up to 20 symbols, Unicode	NULL is not allowed
--Address	String up to 20 symbols, Unicode	NULL is not allowed
--Phone	String with exactly 10 symbols	None
--SubjectId	Integer from 0 to 2,147,483,647	NULL is not allowed, Relationship with table Subjects


--StudentsTeachers
--Column	Data Type	Constraints
--StudentId	Integer from 0 to 2,147,483,647	NULL is not allowed, Relationship with table Students
--TeacherId	Integer from 0 to 2,147,483,647	NULL is not allowed, Relationship with table Teachers

--1. Database Design
--Submit all of yours create statements to the Judge system.


--Section 2. DML (10 pts)
--Before you start, you must import “DataSet-School.sql”. If you have created the structure correctly, the data should be successfully inserted without any errors.
--In this section, you have to do some data manipulations:
--2. Insert
--Insert some sample data into the database. Write a query to add the following records into the corresponding tables. All Ids should be auto-generated.
INSERT INTO Teachers (FirstName,	LastName,	Address,	Phone,	SubjectId)
VALUES
('Ruthanne',	'Bamb',		'84948 Mesta Junction',		3105500146,	6),
('Gerrard',		'Lowin',	'370 Talisman Plaza',		3324874824,	2),
('Merrile',		'Lambdin',	'81 Dahle Plaza',			4373065154,	5),
('Bert',		'Ivie',		'2 Gateway Circle',			4409584510,	4)

INSERT INTO Subjects (Name,	Lessons)
VALUES
('Geometry',12),
('Health',	10),
('Drama	',	7 ),
('Sports',	9 )

--Teachers
--FirstName	LastName	Address	Phone	SubjectId
--Ruthanne	Bamb	84948 Mesta Junction	3105500146	6
--Gerrard	Lowin	370 Talisman Plaza	3324874824	2
--Merrile	Lambdin	81 Dahle Plaza	4373065154	5
--Bert	Ivie	2 Gateway Circle	4409584510	4
--Subjects
--Name	Lessons
--Geometry	12
--Health	10
--Drama	7
--Sports	9


--3. Update
--Make all grades 6.00, where the subject id is 1 or 2, if the grade is above or equal to 5.50
SELECT *
FROM StudentsSubjects
WHERE SubjectId IN (1, 2) AND Grade >= 5.50

UPDATE StudentsSubjects
SET Grade = 6
WHERE SubjectId IN (1, 2) AND Grade >= 5.50


--4. Delete
--Delete all teachers, whose phone number contains ‘72’.
SELECT Id
FROM Teachers
WHERE Phone LIKE '%72%'

DELETE
FROM StudentsTeachers
WHERE TeacherId IN (SELECT Id
FROM Teachers
WHERE Phone LIKE '%72%')

DELETE
FROM Teachers
WHERE Phone LIKE '%72%'

--Section 3. Querying (40 pts)
--You need to start with a fresh dataset, so recreate your DB and import the sample data again (DataSet-School.sql).
--5. Teen Students
--Select all students who are teenagers (their age is above or equal to 12). Order them by first name (alphabetically), then by last name (alphabetically). Select their first name, last name and their age.
SELECT FirstName, LastName, Age
FROM Students
WHERE Age >= 12
ORDER BY FirstName, LastName


--Example
--FirstName	LastName	Age
--Agace	Sneddon	12
--Andres	Colliard	12
--Brose	Yeats	13
--Casper	Tite	12
--…	…	…


--6. Cool Addresses
--Select all full names from students, whose address text contains ‘road’.
--Order them by first name (alphabetically), then by last name (alphabetically), then by address text (alphabetically).
SELECT CONCAT(FirstName, ' ' , MiddleName , ' ' , LastName) AS [Full Name]
	, [Address]
FROM Students
WHERE [Address] LIKE '%road%'
--WHERE  CHARINDEX('road', [Address]) > 0
ORDER BY FirstName, LastName, Address

--Example
--Full Name	Address
--Clywd Jon Dyett	1513 Lien Road
--Garnet Lax De Cleyne	91 Maple Road
--Harland Trelevan Samber	89863 Leroy Road
--Lock Kenford Houlaghan	3 Hovde Road
--…	…

--7. 42 Phones
--Select students with middle names whose phones starts with 42. Select their first name, address and phone number. Order them by first name alphabetically.
SELECT FirstName, Address, Phone
FROM Students
WHERE MiddleName IS NOT NULL AND Phone LIKE '42%'
ORDER BY FirstName

--Example
--FirstName	Address	Phone
--Chloe	520 Sauthoff Pass	4216471468
--Freddie	5 Basil Junction	4205378077
--…	…	…

--8. Students Teachers
--Select all students and the count of teachers each one has. 
SELECT s.FirstName, s.LastName, COUNT(st.TeacherId) AS TeachersCount
FROM Students AS s
	JOIN StudentsTeachers AS st ON s.Id = st.StudentId
GROUP BY s.FirstName, s.LastName
--Example
--FirstName	LastName	TeachersCount
--Sandy	Abbison	10
--Baxter	Abrahart	13
--Demott	Addison	13
--Deane	Adess	10
--…	…	...

--9. Subjects with Students
--Select all teachers’ full names and the subjects they teach with the count of lessons in each. Finally select the count of students each teacher has. Order them by students count descending.
SELECT t.FirstName + ' ' + t.LastName AS [FullName], s.Name + '-' + FORMAT(s.Lessons, 'N0') AS Subjects, COUNT(st.StudentId) AS Students
FROM Teachers AS t
	LEFT JOIN Subjects AS s ON t.SubjectId = s.Id
	 JOIN StudentsTeachers AS st ON st.TeacherId = t.Id
GROUP BY   t.FirstName, t.LastName, s.Name, s.Lessons
ORDER BY Students DESC

--Example
--FullName	Subjects	Students
--Rona Wollard	Physics-12	90
--Salvador Depport	French-15	90
--Ruthanne Bamb	Biology-12	90
--Merrile Lambdin	English-7	90
--Ezechiel Dalinder	Poetry-10	80
--…	…	…

--10. Students to Go
--Find all students, who have not attended an exam. Select their full name (first name + last name).
--Order the results by full name (ascending).
SELECT FirstName + ' ' + LastName AS [Full Name]
FROM Students AS s
	LEFT JOIN StudentsExams AS se ON s.Id = se.StudentId
WHERE Grade IS NULL
ORDER BY [Full Name]
--Example
--Full Name
--Bernardine Purrier
--…
--11. Busiest Teachers
--Find top 10 teachers with most students they teach. Select their first name, last name and the amount of students they have. Order them by students count (descending), then by first name (ascending), then by last name (ascending).
SELECT TOP(10) t.FirstName, t.LastName, COUNT(st.StudentId) AS StudentsCount
FROM Teachers AS t
	JOIN StudentsTeachers AS st ON t.Id = st.TeacherId
GROUP BY t.Id, t.FirstName, t.LastName
ORDER BY StudentsCount DESC, t.FirstName, t.LastName

--Example
--FirstName	LastName	StudentsCount
--Merrile	Lambdin	90
--Rona	Wollard	90
--Ruthanne	Bamb	90
--…	…	
--12. Top Students
--Find top 10 students, who have highest average grades from the exams.
--Format the grade, two symbols after the decimal point.
--Order them by grade (descending), then by first name (ascending), then by last name (ascending)
SELECT TOP(10) s.FirstName, s.LastName, FORMAT(AVG(se.Grade), 'N2') AS Grade
FROM Students AS s
	JOIN StudentsExams AS se ON s.Id = se.StudentId
GROUP BY s.Id, s.FirstName, s.LastName
ORDER BY Grade DESC, FirstName, LastName
	
--Example
--First Name	Last Name	Grade
--Lurlene	Orgee	6.00
--Ivy	Bilovsky	5.70
--Chariot	Giacobbo	5.50
--…	…	

--13. Second Highest Grade
--Find the second highest grade per student from all subjects. Sort them by first name (ascending), then by last name (ascending).
SELECT FirstName, LastName, Grade
FROM (SELECT FirstName
		, LastName
		, Grade
		, ROW_NUMBER() OVER (PARTITION BY s.Id ORDER BY Grade DESC) AS RowNumber 
	FROM Students AS s
		JOIN StudentsSubjects AS ss ON s.Id = ss.StudentId
		) AS k
WHERE RowNumber = 2
ORDER BY FirstName, LastName



--Example
--FirstName	LastName	Grade
--Agace	Sneddon	5.99
--Anderea	Bowers	5.99
--Andres	Colliard	5.99
--Barbe	Sterrie	5.75
--Baxter	Abrahart	5.99
--…	…	…

--14. Not So In The Studying
--Find all students who don’t have any subjects. Select their full name. The full name is combination of first name, middle name and last name. Order the result by full name
--NOTE: If the middle name is null you have to concatenate the first name and last name separated with single space.
SELECT FirstName + ' ' + IIF(MiddleName IS NULL, '', MiddleName + ' ' ) + LastName AS [Full Name]
FROM Students AS s
	LEFT JOIN StudentsSubjects AS ss ON s.Id = ss.StudentId
WHERE ss.SubjectId IS NULL
ORDER BY [Full Name]

--Example
--Full Name
--Allen Storre Piniur
--Andria Geleman Andrioletti
--Ashley Morecombe Summerell
--Bobby Leggitt Domnin
--…
--15. Top Student per Teacher
--Find all teachers with their top students. The top student is the person with highest average grade. Select teacher full name (first name + last name), subject name, student full name (first name + last name) and corresponding grade. The grade must be formatted to the second digit after the decimal point.
--Sort the results by subject name (ascending), then by teacher full name (ascending), then by grade (descending)
SELECT [Teacher Full Name]
	, k.Name AS [Subject Name]
	, k.Student AS [Student Full Name]
	, k.Grade
FROM
(
	SELECT t.FirstName + ' ' + t.LastName AS [Teacher Full Name] 
		, s.FirstName + ' ' + s.LastName AS Student
		, sj.Name
		, FORMAT(AVG(ss.Grade),'N2') AS Grade
		, ROW_NUMBER() OVER (PARTITION BY st.TeacherId, sj.Id ORDER BY AVG(ss.Grade) DESC) AS RowNumber 
	FROM StudentsTeachers AS st
		JOIN Students AS s ON st.StudentId = s.Id
		JOIN StudentsSubjects AS ss ON s.Id = ss.StudentId
		JOIN Subjects AS sj ON ss.SubjectId = sj.Id
		JOIN Teachers AS t ON st.TeacherId = t.Id
	WHERE t.SubjectId = ss.SubjectId
	GROUP BY sj.Id, s.Id, s.FirstName, s.LastName, sj.Name, st.TeacherId, t.FirstName, t.LastName 
 
) AS k

WHERE RowNumber = 1
ORDER BY [Subject Name], [Teacher Full Name], k.Grade DESC

--Example
--Teacher Full Name	Subject Name	Student Full Name	Grade
--Farleigh Gerrans	Art	Horatia Kenforth	5.50
--Findlay Collingdon	Art	Zackariah Cordner	5.27
--Ruthanne Bamb	Biology	Merrill Habbijam	5.75
--…	…	…	…
--16. Average Grade per Subject
--Find the average grade for each subject. Select the subject name and the average grade. 
--Sort them by subject id (ascending).
SELECT s.Name, AVG(ss.Grade) AS AverageGrade
FROM Subjects AS s
	JOIN StudentsSubjects AS ss ON s.Id = ss.SubjectId
GROUP BY s.Id, s.Name
ORDER BY s.Id

--Example
--Name	AverageGrade
--Biology	4.059055
--History	3.880370
--English	4.060546
--Math	3.957876
--Music	3.923984
--Art	4.070898
--…	…
--17. Exams Information
--Divide the year in 4 quarters using the exam dates. For each quarter get the subject name and the count of students who took the exam with grade more or equal to 4.00. If the date is missing, replace it with “TBA”. Order them by quarter ascending.

SELECT IIF(DATEPART ( QUARTER , date ) IS NULL, 'TBA',  'Q'+ FORMAT(DATEPART ( QUARTER , date ),'N0')) AS [Quarter]
	, [Name] AS SubjectName 
	, COUNT( StudentId) AS [Students]
FROM Subjects AS s
	JOIN Exams AS e ON s.Id = e.SubjectId
	JOIN StudentsExams AS se ON e.Id = se.ExamId
WHERE Grade >= 4.00 
GROUP BY DATEPART ( QUARTER , date ), Name
ORDER BY [Quarter], SubjectName

--Example
--Quarter	SubjectName	StudentsCount
--Q1	English	10
--Q1	French	12
--Q1	Physics	8
--Q2	English	10
--…	…	…
--Section 4. Programmability (20 pts)
--18. Exam Grades
--Create a user defined function, named udf_ExamGradesToUpdate(@studentId, @grade), that receives a student id and grade.
--The function should return the count of grades, for the student with the given id, which are above the received grade and under the received grade with 0.50 added (example: you are given grade 3.50 and you have to find all grades for the provided student which are between 3.50 and 4.00 inclusive):
--If the condition is true, you must return following message in the format:
--•	 “You have to update {count} grades for the student {student first name}”
--If the provided student id is not in the database the function should return “The student with provided id does not exist in the school!”
--If the provided grade is above 6.00 the function should return “Grade cannot be above 6.00!”
--Note: Do not update any records in the database!
CREATE FUNCTION udf_ExamGradesToUpdate(@studentId INT, @grade DECIMAL(3,2))
RETURNS NVARCHAR(100)
AS
BEGIN
	DECLARE @student NVARCHAR(100) = (SELECT FirstName FROM Students WHERE Id = @studentId) 

	IF(@student IS NULL)
	BEGIN
		RETURN 'The student with provided id does not exist in the school!'
	END

	IF(@grade > 5.50)
	BEGIN
		RETURN 'Grade cannot be above 6.00!'
	END

	DECLARE @greadCount INT = (
		SELECT COUNT(StudentId) 
		FROM StudentsExams 
		WHERE StudentId = @studentId AND Grade BETWEEN @grade AND @grade + 0.50
		GROUP BY StudentId) 

	RETURN 'You have to update ' + FORMAT(@greadCount, 'N0') + ' grades for the student ' + @student

END

--Example:
--Query
SELECT dbo.udf_ExamGradesToUpdate(12, 6.20)
--Output
--Grade cannot be above 6.00!

--Query				
SELECT dbo.udf_ExamGradesToUpdate(12, 5.50)
--Output
--You have to update 2 grades for the student Agace

--Query
SELECT dbo.udf_ExamGradesToUpdate(121, 5.50)
--Output
--The student with provided id does not exist in the school!


--19. Exclude from school
--Create a user defined stored procedure, named usp_ExcludeFromSchool(@StudentId), that receives a student id and attempts to delete the current student. A student will only be deleted if all of these conditions pass:
--•	If the student doesn’t exist, then it cannot be deleted. Raise an error with the message “This school has no student with the provided id!”
--If all the above conditions pass, delete the student and ALL OF HIS REFERENCES!
CREATE PROCEDURE usp_ExcludeFromSchool(@StudentId INT)
AS
BEGIN
	BEGIN TRANSACTION
	DECLARE @student INT = (SELECT Id FROM Students WHERE Id = @studentId) 

	IF(@student IS NULL)
	BEGIN
		ROLLBACK
		RAISERROR('This school has no student with the provided id!', 16, 1)
		RETURN
	END

	DELETE
	FROM StudentsTeachers
	WHERE StudentId = @StudentId

	DELETE
	FROM StudentsSubjects
	WHERE StudentId = @StudentId

	DELETE
	FROM StudentsExams
	WHERE StudentId = @StudentId

	DELETE
	FROM Students	
	WHERE Id = @StudentId

	COMMIT
END
--Example usage:
--Query	Output
--EXEC usp_ExcludeFromSchool 1
--SELECT COUNT(*) FROM Students	119
--EXEC usp_ExcludeFromSchool 301	This school has no student with the provided id!
--20. Deleted Student
--Create a new table “ExcludedStudents” with columns (StudentId, StudentName). Create a trigger, which fires when student is excluded. After excluding the student, insert all of the data into the new table “ExcludedStudents”.
CREATE TABLE ExcludedStudents
(
	StudentId INT
	, StudentName NVARCHAR(150)
)

CREATE TRIGGER tr_ExcludedStudents ON Students AFTER DELETE
AS
	INSERT INTO ExcludedStudents ( StudentId, StudentName)
	SELECT Id, CONCAT(FirstName, ' ' , LastName) FROM deleted

--Note: Submit only your CREATE TRIGGER statement!
--Example usage:
--Query
--DELETE FROM StudentsExams
--WHERE StudentId = 1

--DELETE FROM StudentsTeachers
--WHERE StudentId = 1

--DELETE FROM StudentsSubjects
--WHERE StudentId = 1

--DELETE FROM Students
--WHERE Id = 1

--SELECT * FROM ExcludedStudents
--Response
--(2 rows affected)

--(14 rows affected)

--(31 rows affected)

--(1 row affected)

--(1 row affected)

