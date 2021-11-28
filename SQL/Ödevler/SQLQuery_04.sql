--Correlated Subquery
-- Hiç sipariþ vermemiþ müþteriler
SELECT CustomerID
FROM Sales.Customer as c
WHERE NOT EXISTS (
SELECT soh.CustomerID
FROM Sales.SalesOrderHeader as soh
WHERE soh.CustomerID = c.CustomerID)

-- Manuel olarak id atamak
SET IDENTITY_INSERT dbo.Musteri ON
Insert dbo.Musteri(MusteriID,AdSoyad,KayitTarihi,Adres,AktifMi) values(2, 'Ýrem Selin Kahya', '2019-05-25', 'Eyüp', 1)
SET IDENTITY_INSERT dbo.Musteri OFF

Select * From dbo.Musteri

-- Girilen metin kaç karakter uzunluðunda 
SELECT LEN('ÝREM SELÝN KAHYA')

-- Girilen kolondaki deðerin diskte kapladýðý yer 
select datalength(Adres)
from dbo.Musteri

-- Subquerylerde içerden 1den fazla sonuç geldiðinde dýþarýdaki filtre operatörü olarak <, > kullanýlrsa hata vermemesi için ne yapmalýyýz?
-- ALL ya da ANY kullanýlýr.
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

-- Yýllar ayný kalacak, aylar sütunda gelecek (matrix)
select *
from (
select year(OrderDate) as yýl, MONTH(OrderDate) as ay, sum(SubTotal) as ciro 
from Sales.SalesOrderHeader
group by year(OrderDate), month(OrderDate)) as tablo
pivot(sum(ciro) for ay in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) as [Pivot]



