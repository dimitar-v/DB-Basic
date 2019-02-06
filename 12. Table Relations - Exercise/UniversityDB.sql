/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION

CREATE TABLE dbo.Subjects
	(
	SubjectID int NOT NULL IDENTITY (1, 1),
	SubjectName varchar(50) NOT NULL
	)  ON [PRIMARY]

ALTER TABLE dbo.Subjects ADD CONSTRAINT
	PK_Subjects PRIMARY KEY CLUSTERED 
	(
	SubjectID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


ALTER TABLE dbo.Subjects SET (LOCK_ESCALATION = TABLE)

COMMIT
BEGIN TRANSACTION

CREATE TABLE dbo.Majors
	(
	MajorID int NOT NULL IDENTITY (1, 1),
	Name varchar(50) NOT NULL
	)  ON [PRIMARY]

ALTER TABLE dbo.Majors ADD CONSTRAINT
	PK_Majors PRIMARY KEY CLUSTERED 
	(
	MajorID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


ALTER TABLE dbo.Majors SET (LOCK_ESCALATION = TABLE)

COMMIT
BEGIN TRANSACTION

CREATE TABLE dbo.Students
	(
	StudentID int NOT NULL IDENTITY (1, 1),
	StudentNumber varchar(15) NOT NULL,
	StudentName varchar(50) NOT NULL,
	MajorID int NULL
	)  ON [PRIMARY]

ALTER TABLE dbo.Students ADD CONSTRAINT
	PK_Students PRIMARY KEY CLUSTERED 
	(
	StudentID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


ALTER TABLE dbo.Students ADD CONSTRAINT
	FK_Students_Majors FOREIGN KEY
	(
	MajorID
	) REFERENCES dbo.Majors
	(
	MajorID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	

ALTER TABLE dbo.Students SET (LOCK_ESCALATION = TABLE)

COMMIT
BEGIN TRANSACTION

CREATE TABLE dbo.Agenda
	(
	StudentID int NOT NULL,
	SubjectID int NOT NULL
	)  ON [PRIMARY]

ALTER TABLE dbo.Agenda ADD CONSTRAINT
	PK_Agenda PRIMARY KEY CLUSTERED 
	(
	StudentID,
	SubjectID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


ALTER TABLE dbo.Agenda ADD CONSTRAINT
	FK_Agenda_Students FOREIGN KEY
	(
	StudentID
	) REFERENCES dbo.Students
	(
	StudentID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	

ALTER TABLE dbo.Agenda ADD CONSTRAINT
	FK_Agenda_Subjects FOREIGN KEY
	(
	SubjectID
	) REFERENCES dbo.Subjects
	(
	SubjectID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	

ALTER TABLE dbo.Agenda SET (LOCK_ESCALATION = TABLE)

COMMIT
BEGIN TRANSACTION

CREATE TABLE dbo.Payments
	(
	PaymentID int NOT NULL IDENTITY (1, 1),
	PaymentDate date NOT NULL,
	PaymentAmount decimal(18, 2) NOT NULL,
	StudentID int NOT NULL
	)  ON [PRIMARY]

ALTER TABLE dbo.Payments ADD CONSTRAINT
	PK_Payments PRIMARY KEY CLUSTERED 
	(
	PaymentID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


ALTER TABLE dbo.Payments ADD CONSTRAINT
	FK_Payments_Students FOREIGN KEY
	(
	StudentID
	) REFERENCES dbo.Students
	(
	StudentID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	

ALTER TABLE dbo.Payments SET (LOCK_ESCALATION = TABLE)

COMMIT