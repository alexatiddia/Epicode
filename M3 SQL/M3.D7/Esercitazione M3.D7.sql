
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



-- Visulizzare data assunzione dei manager e loro ID appartenenti al dipartimento 'Amministrazione' nel formato Nome mese, giorno, anno

SELECT 
	D.IDManager
	,D.NomeDipartimento
	,CONCAT (M.Nome,' ',M.Cognome)		AS	NomeManager
	,DATENAME (dw,M.DataAssunzione)		AS	'Day'
	,DATENAME (m,M.DataAssunzione)		AS	'Month'
	,DATENAME (yy,M.DataAssunzione)		AS	'Year'
FROM Dipartimento AS D
FULL OUTER JOIN Dipendente AS M
ON D.IDManager = M.IDDipendente
WHERE D.NomeDipartimento = 'Amministrazione'

--Visualizare nome e cognome dei dipendenti assunti nel mese di giugno

SELECT 
	CONCAT(Nome, ' ', Cognome)	AS	NomeDipendente
FROM Dipendente
WHERE MONTH(DataAssunzione) = 06

-- Visualizzare gli anni in cui più di 10 dipendenti sono stati assunti

SELECT 
	YEAR(DataAssunzione)	AS	Anno
	,COUNT(DataAssunzione)	AS	NumDip
FROM Dipendente
GROUP BY YEAR(DataAssunzione)
HAVING COUNT(DataAssunzione) > 10

-- Visualizzare il nome del dipartimento, nome manager, salario del manager di tutti i manager la cui esperienza è > 5 anni

SELECT
	I.IDManager
	,D.NomeDipartimento
	,CONCAT(I.Nome, ' ',I.Cognome)				AS	NomeManager
FROM Dipartimento as D
INNER JOIN Dipendente AS I
ON D.IDManager = I.IDDipendente
WHERE DATEDIFF (yy, I.DataAssunzione, GETDATE()) > 5

-- Trovare il manager di ogni dipendente

SELECT 
		D1.IDDipendente
		,CONCAT (D1.Nome, ' ', D1.Cognome)		AS	NomeDipendente
		,D2.IDManager
		,CONCAT (D2.Nome, ' ', D2.Cognome)		AS	NomeManager
		,MONTH (D2.DataAssunzione)				AS	MeseAssunzione
FROM Dipendente AS D1
INNER JOIN Dipendente AS D2
ON D1.IDManager = D2.IDDipendente
WHERE MONTH (D2.DataAssunzione) = 8