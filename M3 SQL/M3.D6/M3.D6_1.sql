
/* Studente (Matricola, Nome, Città)
	Corso (COdice, Nome, MatricolaDocente)
	Docente (Matricola, Nome)
	Esame (Codice, MatricolaStudente, Data, Voto, Settorescientifico)
*/

CREATE DATABASE EsercitazioneD6_1;

CREATE TABLE Studente (
Matricola INT,
Nome VARCHAR (25),
Città VARCHAR (25),
CONSTRAINT PK_Matricola PRIMARY KEY (Matricola))

CREATE TABLE Corso (
CodiceCorso INT,
NomeCorso VARCHAR (25),
MatricolaDocente VARCHAR (25),
CONSTRAINT PK_CodiceCorso PRIMARY KEY (CodiceCorso),
CONSTRAINT FK_MatricolaDocente FOREIGN KEY (MatricolaDocente) REFERENCES Docente(MatricolaDocente));

CREATE TABLE Docente (
MatricolaDocente VARCHAR(25),
Nome VARCHAR (25),
CONSTRAINT PK_MatricolaDocente PRIMARY KEY (MatricolaDocente));

CREATE TABLE Esame (
CodiceCorso INT,
MatricolaStudente INT,
Data DATE,
Voto INT,
SettoreScientifico VARCHAR (25),
CONSTRAINT FK_CodiceCorso FOREIGN KEY (CodiceCorso) REFERENCES Corso(CodiceCorso),
CONSTRAINT FK_MatricolaStudente FOREIGN KEY (MatricolaStudente) REFERENCES Studente(Matricola));

INSERT INTO Studente 
VALUES (1, 'Claudia Locci', 'Bologna'), (2, 'Michele Rossi', 'Cagliari'),  (3, 'Daniele Bianchi', 'Parma'),  (4, 'Rosa Viva', 'Reggio Emilia'),  (5, 'Gaia Peis', 'Oristano');

INSERT INTO Corso
VALUES (112056, 'Statistica','BA002'), (265610,'Economia Aziendale','DS001'), (832481,'Ragioneria Applicata','DS001'), (559561,'Diritto privato','PI005'), (594213,'Analisi 2','BA002'),
		(865045,'Diritto Bancario','PI005'), (526719,'Business English','AT001'), (327594,'Programmazione Controllo','DS001'), (203578,'Matematica finanziaria','RG005'), (396578,'Psicologia consumatore','NR001');

INSERT INTO Docente
VALUES ('BA002','Barbara Aghi'), ('DS001','Dario Sassi'), ('PI005','Piero Iva'), ('AT001','Agata Todi'), ('RG005','Rossano Giovi'), ('NR001','Nicola Rossi');

INSERT INTO Esame
VALUES 
(112056,2,'01/02/2022',22,'Statistica'), (265610,2,'25/02/2022',28,'Contabilità'), (832481,2,'15/01/2022',30,'Contabilità'),
(559561,2,'03/06/2022',25,'Diritto'),(594213,2,'25/06/2022',18,'Matematica'), (865045,2,'17/07/2022',25,'Diritto'),
(526719,2,'15/01/2023',27,'Inglese'),(327594,2,'29/01/2023',30,'Contabilità'), (203578,2,'06/02/2023',28,'Matematica'),
(396578,2,'25/02/2023',27,'Psicologia'), (112056,4,'01/02/2022',28,'Statistica'), (265610,4,'25/02/2022',25,'Contabilità'),
(832481,4,'15/01/2022',24,'Contabilità'), (559561,4,'03/06/2022',19,'Diritto'), (594213,4,'25/06/2022',23,'Matematica'),
(865045,4,'17/07/2022',21,'Diritto'),(526719,4,'15/01/2023',30,'Inglese'), (327594,4,'29/01/2023',29,'Contabilità'),
(203578,4,'06/02/2023',30,'Matematica'), (396578,4,'25/02/2023',27,'Psicologia'),(594213,1,'25/06/2022',30,'Matematica'),
(865045,1,'17/07/2022',30,'Diritto'), (526719,1,'15/01/2023',28,'Inglese'), (265610,3,'25/02/2022',27,'Contabilità'),
(832481,3,'15/01/2022',18,'Contabilità'),(396578, 3,'25/02/2023',20,'Psicologia'), (112056, 5,'01/02/2022',30,'Statistica'),
(265610,5,'25/02/2022',28,'Contabilità'),(832481,5,'15/01/2022',27,'Contabilità'), (559561,5,'03/06/2022',29,'Diritto'),
(594213,5,'25/06/2022',18,'Matematica'),(865045,5,'17/07/2022',21,'Diritto'), (526719,5,'15/01/2023',28,'Inglese'), (327594,5,'29/01/2023',25,'Contabilità'),
(203578,5,'06/02/2023',26,'Matematica');



-- Visualizzare per ogni studente la matricola, il nome, il voto massimo, minimo, medio conseguito negli esami

SELECT 
	S.Matricola
	,S.Nome
	,MAX(E.Voto)		AS		VotoMax
	,MIN(E.Voto)		AS		VotoMin
	,AVG(E.Voto)		AS		VotoAVG
FROM Studente AS S
LEFT JOIN Esame AS E
ON S.Matricola = E.MatricolaStudente
GROUP BY S.Matricola, S.Nome

-- Visualizzare, per ogni studente con media voti > 25 e che ha sostenuto esami in almeno 10 date, la matricola, il nome, il voto massimo, minimo, medio conseguito negli esami. Ordina per voto.

SELECT 
	E.MatricolaStudente
	,COUNT(E.Data)	AS CountEsami
	,AVG(E.Voto)		AS		AvgVoto
	,MAX(E.Voto)		AS		MaxVoto
	,MIN(E.Voto)		AS		MinVoto
	,S.Nome
FROM Esame AS E
INNER JOIN Studente AS S
ON E.MatricolaStudente = S.Matricola
GROUP BY E.MatricolaStudente, S.Nome
HAVING COUNT(E.Data) = 10
	AND AVG(E.Voto) > 25



