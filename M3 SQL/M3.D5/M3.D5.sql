
/*
DISCO (NroSerie, TitoloAlbum, Anno, Prezzo)
CONTIENE (NroSerieDisco, CodiceReg, NroProg)
ESECUZIONE (CodiceReg, TitoloCanz, Anno)
AUTORE (Nome, TitoloCanzone)
CANTANTE (NomeCantante, CodiceReg)
*/

1. I cantautori (persone che hanno cantato e scritto la stessa canzone) il cui nome inizia per 'D'

SELECT 
	C.NomeCantante
FROM Cantante AS C
INNER JOIN Autore AS A
ON C.NomeCantante = A.Nome
WHERE C.NomeCantante LIKE 'D%'

2. I titoli dei dischi che contengono canzoni di cui non si conosce anno di registrazione

SELECT 
	D.TitoloAlbum
	, E.Anno
	, E.TitoloCanz
FROM Disco AS D
INNER JOIN Contiene AS C
ON D.NroSerie = C.NroSerieDisco
INNER JOIN Esecuzione AS E
ON C.CodiceReg = E.CodiceReg
WHERE E.Anno is null

3. I cantanti che hanno sempre registrato canzoni come solisti

-- Il codice di registrazione deve essere abbinato ad un solo cantante e ogni cantante deve avere un codice di regristazione non abbinato a nessun altro

SELECT 
		C1.NomeCantante,C1.CodiceReg
		,C2.NomeCantante,C2.CodiceReg
FROM Cantante AS C1
INNER JOIN Cantante AS C2
ON C1.CodiceReg = C2.CodiceReg

-- A questo punto devo trovare i nomecantanti che sono diversi tra le tabelle ma hanno stesso codice in modo da poterli poi escludere

WHERE C1.NomeCantante <> C2.NomeCantante

-- Ora bisogna utilizzare questi valori per esclusione con una query innestata usando la precedente query come esterna che passa una soluzione alla prima interna. Si deve passare un campo non tutta
-- la query altrimenti da errore

SELECT DISTINCT IDCantante, NomeCantante, CodiceReg
FROM  Cantante
WHERE IDCantante NOT IN (

SELECT C1.IDCantante
FROM Cantante AS C1
INNER JOIN Cantante AS C2
ON C1.CodiceReg = C2.CodiceReg
WHERE C1.NomeCantante <> C2.NomeCantante)



/*
STUDENTE (Matricola, Nome, Città)
CORSO (Codice, Nome, MatricolaDocente)
DOCENTE (Matricola, Nome)
ESAME (Codice, MatricolaStudente, Data, Voto, SettoreScientifico)
*/

1. Per ogni studente, visualizzare gli esami sostenuti con voto maggiore di 28 assimee alla matricola dello studente e al nome del docente che ha tenuto il corso.

SELECT 
		S.Matricola		AS  MatricolaStudente
		S.Nome			AS	NomeStudente
		C.Nome			AS	NomeCorso
		E.Voto			AS	VotoEsame
		D.Nome			AS	NomeDocente
FROM Studente AS S
INNER JOIN Esame AS E
ON S.Matricola = E.MatricolaStudente
WHERE VotoEsame > 28
INNER JOIN CORSO AS C
ON E.Codice = C.Codice
INNER JOIN DOCENTE AS D
ON C.MatricolaDocente = D.Matricola

2. Per ogni docente, visualizzare il nome, il nome del corso di cui è titolare e il settore scientifico del corso.

SELECT 
	D.Nome					AS	NomeDocente
	C.Nome					AS	NomeCorso
	E.SettoreScientifico	AS	SettoreCorso
FROM DOCENTE AS D
INNER JOIN CORSO AS C
ON D.Matricola = C.MatricolaDocente
INNER JOIN ESAME AS E
ON C.Codice = E.Codice
