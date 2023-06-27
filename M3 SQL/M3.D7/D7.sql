
CREATE DATABASE D7;
USE DT;

CREATE TABLE Dipendente (
IDDipendente INT,
Nome VARCHAR(25),
Cognome VARCHAR(25),
Email VARCHAR(50),
NumeroTelefono VARCHAR(25),
DataAssunzione DATE,
IDLavoro INT,
IDManager INT,
IDDipartimento INT,
CONSTRAINT PK_IDDipendente PRIMARY KEY (IDDipendente),
CONSTRAINT FK_Dipendente_Dipartimento_IDDipartimento FOREIGN KEY (IDDipartimento)
	REFERENCES Dipartimento (IDDipartimento))

CREATE TABLE Dipartimento (
IDDipartimento INT,
NomeDipartimento VARCHAR(50),
IDManager INT,
IDLocation INT,
CONSTRAINT PK_IDDipartimento PRIMARY KEY (IDDipartimento))

INSERT INTO Dipartimento
VALUES (100, 'Data Analytics', 9, 1), (200, 'Data Science', 10, 2)


INSERT INTO Dipendente 
VALUES 
(1, 'Guy', null, null, null, '2008-08-26', 1, 9,  100)
, (2, 'Laura', 'Norman', null, null, '2008-08-26', 1, 9,  100)
, (3, 'Andy', 'Norman', null, null, '2008-08-26', 1, 9,  100)
, (4, 'Karen', 'Norman', null, null, '2008-08-26', 1, 10,  200)
, (5, 'Barbara', 'Norman', null, null, '2009-06-26', 1, 10,  200)

INSERT INTO Dipendente 
VALUES 
(9, 'Brenda', 'Diaz', null, null, '2007-08-26', 1, 9,  100)
, (10, 'Mary', 'Baker', null, null, '2008-08-26', 1, 9,  100)
