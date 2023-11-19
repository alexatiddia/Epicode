
CREATE DATABASE M3_D8;

-- Esempio di creazione tabelle con vincoli

CREATE TABLE Category (
CategoryID INT,
CategoryName VARCHAR(50),
CONSTRAINT PK_Category_CategoryID PRIMARY KEY (CategoryID));

CREATE TABLE SubCategory (
SubCategoryID INT,
SubCategoryName VARCHAR(50),
CategoryID INT,
CONSTRAINT PK_SubCategory_SubCategoryID PRIMARY KEY (SubCategoryID),
CONSTRAINT FK_SubCategory_CategoryID FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID));

CREATE TABLE Brand (
BrandID INT,
BrandName VARCHAR (50),
CONSTRAINT PK_Brand_BrandID PRIMARY KEY (BrandID));

CREATE TABLE Product (
ProductID INT,
ProductName VARCHAR (50),
BrandID INT,
SubCategoryID INT,
LimitedEdition INT,
New INT,
OutOfStock INT,
CONSTRAINT PK_Product_ProductID PRIMARY KEY (ProductID),
CONSTRAINT FK_Product_BrandID FOREIGN KEY (BrandID) REFERENCES Brand(BrandID),
CONSTRAINT FK_Product_SubCategoryID FOREIGN KEY (SubCategoryID) REFERENCES SubCategory(SubCategoryID));

CREATE TABLE Customer (
CustomerID VARCHAR (10),
CONSTRAINT PK_Customer_CustomerID PRIMARY KEY (CustomerID));

CREATE TABLE "Order" (
OrderID INT,
"Date" DATE,
CustomerID VARCHAR(10),
ProductID INT,
PriceProduct MONEY,
Quantity INT,
CONSTRAINT PK_Order_OrderID PRIMARY KEY (OrderID),
CONSTRAINT FK_Order_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
CONSTRAINT FK_ORder_ProductID FOREIGN KEY (ProductID) REFERENCES Product(ProductID));

-- Inserimento dati tramite Import File CSV

SELECT *
FROM Category

SELECT *
FROM SubCategory

SELECT *
FROM Product

SELECT *
FROM Brand

SELECT *
FROM Customer

SELECT *
FROM Sales

-- Modifica valori

ALTER TABLE Product ALTER COLUMN ProductPrice MONEY;  
ALTER TABLE Sales	ALTER COLUMN ProductPrice MONEY;

-- Creazione vincoli esterni tra le tabelle

ALTER TABLE SubCategory
ADD CONSTRAINT FK_SubCategory_CategoryID FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID);

ALTER TABLE Product
ADD CONSTRAINT FK_Product_BrandID FOREIGN KEY (BrandID) REFERENCES Brand(BrandID),
ADD CONSTRAINT FK_Product_SubCategoryID FOREIGN KEY (SubCategoryID) REFERENCES SubCategory(SubCategoryID);

ALTER TABLE Sales
ADD CONSTRAINT FK_Sales_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
ADD CONSTRAINT FK_Sales_ProductID FOREIGN KEY (ProductID) REFERENCES Product(ProductID);


-- 1) Calcolare fatturato del 2021 per categoria e sotto categoria di prodotto ordinati in modo ascendente

SELECT 
		C.CategoryName
		,SC.SubCategoryName
		,SUM(S.ProductPrice*S.Quantity)		AS		SalesAmount2021
FROM Sales AS S
INNER JOIN Product AS P
ON S.ProductID = P.ProductID
INNER JOIN SubCategory AS SC
ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN Category AS C
ON SC.CategoryID = C.CategoryID
WHERE YEAR(S.OrderDate) = 2021
GROUP BY SC.SubCategoryName, C.CategoryName
ORDER BY C.CategoryName ASC, SC.SubCategoryName ASC


-- 2) Calcolare i prodotti venduti che hanno un prezzo > 150 euro ordinati in modo decrescente

SELECT DISTINCT
	P.ProductName
	,P.ProductPrice
FROM Product AS P
INNER JOIN Sales AS S
ON P.ProductID = S.ProductID
WHERE P.ProductPrice > 150
ORDER BY P.ProductPrice DESC


-- 3) Calcolare quanti ordini ha fatto ciascun cliente e con quale importo a gennaio 2022

SELECT
	S.CustomerID
	,COUNT(S.OrderID)					AS		OrderQuantity
	,SUM(S.ProductPrice*S.Quantity)		AS		SalesAmount2022
FROM Sales AS S
WHERE YEAR(S.OrderDate) = 2022 AND MONTH(S.OrderDate) = 01
GROUP BY S.CustomerID
ORDER BY OrderQuantity DESC


-- 4) Calcolare i prodotti che non sono stati venduti nè nel 2021 nè 2022

SELECT P.ProductID, P.ProductName
FROM  Product AS P
WHERE ProductID NOT IN (SELECT S.ProductID
						FROM Sales AS S
						WHERE YEAR(S.OrderDate) IN (2021,2022))
ORDER BY P.ProductName ASC


-- 5) Calcolare, per ogni marca, il prezzo minore e massimo dei prodotti

SELECT
	B.BrandName
	,MIN(P.ProductPrice)			AS		MinPrice
	,MAX(P.ProductPrice)			AS		MaxPrice
FROM Product AS P
INNER JOIN Brand AS B
ON P.BrandID = B.BrandID
GROUP BY B.BrandName
ORDER BY B.BrandName ASC


-- 6) Calcolare se il prezzo dei prodotti LimitedEdition è superiore o meno al prezzo medio dei prodotti della stessa marca

SELECT 
	P.ProductID
	,P.ProductName
	,P.ProductPrice
	,BP.AVGPrice
	,CASE
		WHEN P.ProductPrice > BP.AVGPrice THEN 1
		WHEN P.ProductPrice >= BP.AVGPrice THEN 0
		ELSE ''
		END  "PriceLE>PriceAVG"
FROM (
		SELECT
			P.BrandID
			,AVG(P.ProductPrice)		AS		AVGPrice
		FROM Product AS P
		WHERE P.LimitedEdition = 0
		GROUP BY P.BrandID) BP
INNER JOIN Product AS P
ON BP.BrandID = P.BrandID
WHERE P.LimitedEdition = 1
ORDER BY P.ProductName ASC


-- 7) Calcolare quanti prodotti esistono per ogni categoria prodotto

SELECT 
		C1.CategoryName
		,COUNT(P.ProductID)		AS ProductCount
FROM (
		SELECT 
			C.CategoryName
			,SC.SubCategoryID
		FROM Category AS C
		INNER JOIN SubCategory AS SC
		ON C.CategoryID = SC.CategoryID) AS C1
INNER JOIN Product AS P
ON C1.SubCategoryID = P.SubCategoryID
GROUP By C1.CategoryName
ORDER BY C1.CategoryName ASC


-- 8) Calcolare l'importo dell'ordine più recente per ogni cliente

SELECT
	S.CustomerID
	,MAX(S.OrderDate)					AS		LastOrder
	,SUM(S.ProductPrice*S.Quantity)		AS		SalesAmount
FROM Sales AS S
GROUP BY S.CustomerID
ORDER BY LastOrder DESC


-- 9) Windows Function relativa al 2022

SELECT
	ProductId
	,OrderDate
	,ProductPrice*Quantity		AS		SalesAmount
	,SUM(ProductPrice*Quantity) OVER (PARTITION BY ProductID
										 ORDER BY OrderDate
										 ROWS BETWEEN UNBOUNDED PRECEDING
                                         AND CURRENT ROW) AS RunningSales
FROM Sales
WHERE YEAR(OrderDate) = 2022


-- 10) Calcolare le TOP 5 msrche che hanno venduto di più nel 2021

SELECT TOP 5
		B.BrandID
		,B.BrandName
		,TB.OrderQuantity
		,TB.SalesAmount
FROM (
		SELECT
			P.BrandID
			,COUNT(S.OrderID)					AS	OrderQuantity
			,SUM(S.ProductPrice*S.Quantity)		AS	SalesAmount
		FROM Product AS P
		INNER JOIN Sales AS S
		ON P.ProductID = S.ProductId
		WHERE YEAR(S.OrderDate) = 2021
		GROUP BY P.BrandID)	AS TB
INNER JOIN Brand AS B
ON TB.BrandID = B.BrandID
ORDER BY TB.SalesAmount DESC


-- Creazione vistE per denormalizzare i dati da importare poi su Excel

CREATE VIEW AT_Product AS (
SELECT 
	P.ProductID
	,P.ProductName
	,P.LimitedEdition
	,P.OutOfStock
	,P.New
	,P.ProductPrice
	,B.BrandID
	,B.BrandName
	,SC.SubCategoryID
	,SC.SubCategoryName
	,C.CategoryID
	,C.CategoryName
FROM Product AS P
FULL OUTER JOIN Brand AS B
ON P.BrandID = B.BrandID
FULL OUTER JOIN SubCategory AS SC
ON SC.SubCategoryID = P.SubCategoryID
FULL OUTER JOIN Category AS C
ON C.CategoryID = SC.CategoryID)


SELECT *
FROM AT_Product

CREATE VIEW AT_Sales AS(
SELECT 
	S.OrderID
	,S.OrderDate
	,S.ProductId
	,S.ProductPrice
	,S.Quantity
	,C.CustomerID
FROM Sales AS S
FULL OUTER JOIN Customer AS C
ON S.CustomerID = C.CustomerID)

SELECT *
FROM AT_Sales