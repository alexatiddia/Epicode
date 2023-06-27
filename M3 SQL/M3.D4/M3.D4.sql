


AEREOPORTO (Citt‡, Nazione, NumPiste)
VOLO (IDVolo, GiornoSett, Citt‡Part, OraPart, Citt‡Arr, OraArr, TipoAereo)
AEREO (TipoAereo, NumPasseggeri, QtaMerci)

1. Le citt‡ con un aereoporto di cui non Ë noto il numero di piste

SELECT Citt‡, NumPiste
FROM Aeroporto
WHERE NumPiste IS NULL

2. I tipi di aereo usati nei voli che partono da Torino

SELECT TipoAereo, Citt‡Part
FROM Volo
WHERE Citt‡Part = 'Torino'

3. Le citt‡ da cui partono voli diretti a Bologna

SELECT Citt‡Part, Citt‡Arr
FROM Volo
WHERE Citt‡Arr = 'Bologna'

4. Le citt‡ da cui parte e arriva il volo con codice AZ274

SELECT Citt‡Part, Citt‡Arr, IDVolo
FROM Volo
WHERE IDVolo = 'AZ274'

5. Il tipo di aereo, il giorno della settimana, lorario di partenza la cui citt‡ di partenza inizia per B e contiene O e la cui citt‡ di arrivo termina con A e contiene E

SELECT TipoAereo, GiornoSett, OraPart, Citt‡Part, Citt‡Arr
FROM Volo
WHERE Citt‡Part LIKE B%O%
	AND Citt‡Arr LIKE %E%A