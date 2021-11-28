-- 2 adet sorgu yazýlacak, execution planý inecelenecek
-- index scan --> index seek cevirecek gerekli olan idexi olusturun
select BusinessEntityID, JobTitle, Gender
from HumanResources.Employee
where JobTitle like 'marketing%'

/*
BusinessEntityID -> primary key = clustered index
Clustered index scan -> 0.008
JobTitle -> nonclustered index
Nonclustered index seek -> 0.003
*/

-- 2. ornek
select ProductID
from Production.Product
where SellStartDate between '2012-05-30' and '2013-05-30'

/*
ProductID -> primary key = clustered index
Clustered index scan -> 0.012
SellStartDate -> nonclustered index
Nonclustered index seek -> 0.003
*/

-- icinde Price kelimesi gecen kolonlari ve tablo adini getiren sorguyu yazin.
select table_name, column_name
from INFORMATION_SCHEMA.COLUMNS
where column_name like '%price%' 