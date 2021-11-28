--Correlated Subquery
-- Hi� sipari� vermemi� m��teriler
SELECT CustomerID
FROM Sales.Customer as c
WHERE NOT EXISTS (
SELECT soh.CustomerID
FROM Sales.SalesOrderHeader as soh
WHERE soh.CustomerID = c.CustomerID)

-- Manuel olarak id atamak
SET IDENTITY_INSERT dbo.Musteri ON
Insert dbo.Musteri(MusteriID,AdSoyad,KayitTarihi,Adres,AktifMi) values(2, '�rem Selin Kahya', '2019-05-25', 'Ey�p', 1)
SET IDENTITY_INSERT dbo.Musteri OFF

Select * From dbo.Musteri

-- Girilen metin ka� karakter uzunlu�unda 
SELECT LEN('�REM SEL�N KAHYA')

-- Girilen kolondaki de�erin diskte kaplad��� yer 
select datalength(Adres)
from dbo.Musteri

-- Subquerylerde i�erden 1den fazla sonu� geldi�inde d��ar�daki filtre operat�r� olarak <, > kullan�lrsa hata vermemesi i�in ne yapmal�y�z?
-- ALL ya da ANY kullan�l�r.
SELECT * 
FROM Sales.SalesOrderHeader
WHERE SubTotal < all
	(SELECT SubTotal
	FROM Sales.SalesOrderHeader
	WHERE TerritoryID = '1')

SELECT * 
FROM Sales.SalesOrderHeader
WHERE SubTotal > any
	(SELECT SubTotal
	FROM Sales.SalesOrderHeader
	WHERE TerritoryID = '1')

-- Y�llar ayn� kalacak, aylar s�tunda gelecek (matrix)
select *
from (
select year(OrderDate) as y�l, MONTH(OrderDate) as ay, sum(SubTotal) as ciro 
from Sales.SalesOrderHeader
group by year(OrderDate), month(OrderDate)) as tablo
pivot(sum(ciro) for ay in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) as [Pivot]



