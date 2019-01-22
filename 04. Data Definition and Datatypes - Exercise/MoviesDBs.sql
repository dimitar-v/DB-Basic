-- 13 Movies Database

--CREATE DATABASE Movies 
--GO
--USE Movies

CREATE TABLE Directors 
(
	Id INT IDENTITY,
	DirectorName NVARCHAR(50) NOT NULL,
	Notes NVARCHAR(MAX),
	CONSTRAINT PK_Directors PRIMARY KEY (Id)
)

INSERT INTO Directors VALUES
('Steven Spielberg', 'One of the most influential personalities in the history of cinema, Steven Spielberg is Hollywood best known director and one of the wealthiest filmmakers in the world.'),
('Martin Scorsese', NULL),
('John Woo', 'Born in southern China, John Woo grew up in Hong Kong, where he began his film career as an assistant director in 1969, working for Shaw Brothers Studios.'),
('Quentin Tarantino', 'Quentin Jerome Tarantino was born in Knoxville, Tennessee. His father, Tony Tarantino, is an Italian-American actor and musician from New York, and his mother, Connie (McHugh), is a nurse from Tennessee.'),
('Clint Eastwood', 'Clint Eastwood was born May 31, 1930 in San Francisco, the son of Clinton Eastwood Sr., a manufacturing executive for Georgia-Pacific Corporation, and Ruth Wood, a housewife turned IBM operator.')

SELECT * FROM Directors

-- DROP TABLE Genres
CREATE TABLE Genres 
(
	Id INT IDENTITY,
	GenreName NVARCHAR(20) NOT NULL,
	Notes NVARCHAR(MAX),
	CONSTRAINT PK_Genres PRIMARY KEY (Id)
)

INSERT INTO Genres VALUES
('Action', NULL),
('Adventure', NULL),
('Crime', NULL),
('Sci-Fi', NULL),
('Comedy', NULL)

SELECT * FROM Genres

-- DROP TABLE Categories 
CREATE TABLE Categories 
(
	Id INT IDENTITY,
	CategoryName NVARCHAR(5) NOT NULL,
	Notes NVARCHAR(MAX),
	CONSTRAINT PK_Categories PRIMARY KEY (Id)
)

INSERT INTO Categories VALUES
('G', 'All ages admitted. Nothing that would offend parents for viewing by children.'),
('PG', 'Some material may not be suitable for children. Parents urged to give "parental guidance". May contain some material parents might not like for their young children.'),
('PG-13', 'Some material may be inappropriate for children under 13. Parents are urged to be cautious. Some material may be inappropriate for pre-teenagers.'),
('R', 'Under 17 requires accompanying parent or adult guardian. Contains some adult material. Parents are urged to learn more about the film before taking their young children with them.'),
('NC-17', 'No One 17 and Under Admitted. Clearly adult. Children are not admitted.')

SELECT * FROM Categories

-- DROP TABLE Movies 
CREATE TABLE Movies 
(
	Id INT IDENTITY,
	Title NVARCHAR(120) NOT NULL, 
	DirectorId INT NOT NULL, 
	CopyrightYear INT NOT NULL, 
	Length INT NOT NULL, 
	GenreId INT, 
	CategoryId INT, 
	Rating DECIMAL(2, 1), 
	Notes NVARCHAR(MAX),
	CONSTRAINT PK_Movies PRIMARY KEY (Id),
	CONSTRAINT FK_Director FOREIGN KEY (DirectorId) REFERENCES Directors (Id),
	CONSTRAINT FK_Genres FOREIGN KEY (GenreId) REFERENCES Genres (Id),
	CONSTRAINT FK_Categories FOREIGN KEY (CategoryId) REFERENCES Categories (Id),
	CONSTRAINT CHK_MovieLength CHECK (Length > 0),
    CONSTRAINT CHK_Rating CHECK (Rating <= 10)
)

INSERT INTO Movies(Title, DirectorId, CopyrightYear, Length, GenreId, CategoryId, Rating, Notes)
VALUES
('E.T. the Extra-Terrestrial', 1, 1982, 115, 4, 1, 7.9, 'A troubled child summons the courage to help a friendly alien escape Earth and return to his home world.'),
('Taxi Driver', 2, 1976, 114, 3, 2, 8.3, NULL),
('Chi bi', 3, 2008, 146, 1, 4, 7.4, 'The first chapter of a two-part story centered on a battle fought in China Three Kingdoms period (220-280 A.D.).'),
('From Dusk Till Dawn', 4, 1996, 108, 3, 4, 7.3, 'Two criminals and their hostages unknowingly seek temporary refuge in a truck stop populated by vampires, with chaotic results.'),
('The Dead Poo', 5, 1988, 91, 1, 3, 6.3, 'Dirty Harry Callahan must stop a sick secret contest to murder local celebrities, which includes himself as a target.')

SELECT * FROM Movies