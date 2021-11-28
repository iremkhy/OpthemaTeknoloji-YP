-- Baslangic tarihi ve bitis tarihi girilen siparisleri getiren bir sp yaz.
create procedure spTariheGoreSiparisGetir
(
@IlkTarih datetime, 
@SonTarih datetime
)
as
begin
	select SalesOrderID, OrderDate
	from Sales.SalesOrderHeader
	where OrderDate between @IlkTarih and @SonTarih
end

exec spTariheGoreSiparisGetir '2011-05-31', '2011-09-30'

-- Scalar function yazip bir sorgu olustur.
create function fnÝsimUzunluguBul
(
@Ad nvarchar(20),
@Soyad nvarchar(20)
)
returns nvarchar(20)
as
begin
return len(concat(@Ad, @Soyad))
end
select dbo.fnÝsimUzunluguBul('Ýrem', 'Kahya')

-- 2. ornek
CREATE FUNCTION fnKacYýlGecti
(
@CustomerID int
)  
RETURNS int
BEGIN  
RETURN(SELECT top 1 Datediff(YEAR, OrderDate, GETDATE())
        FROM Sales.SalesOrderHeader
        WHERE @CustomerID = CustomerID
		order by OrderDate desc)
END

select dbo.fnKacYýlGecti(11500)

select CustomerID, dbo.fnKacYýlGecti(CustomerID)
from Sales.SalesOrderHeader

select * from Sales.SalesOrderHeader

--	Her musterinin vermis oldugu son 3 siparis gelsin. (sirano kullanarak)
select *
from (
select CustomerID, SalesOrderID, 
		dense_rank() over(partition by customerID order by OrderDate desc) as SiraNo
from Sales.SalesOrderHeader) as tbl
where SiraNo <= 3

-- Kumulatif toplam ve hareketli ortalama getirilecek. (window function)

select YEAR(OrderDate) as Yil, MONTH(OrderDate) as Ay, SUM(SubTotal) as Ciro,
		SUM(SUM(SubTotal)) over(partition by YEAR(orderdate) order by MONTH(OrderDate) asc) as kumulatiftoplam,
		AVG(SUM(SubTotal)) over(partition by YEAR(orderdate) order by MONTH(OrderDate) asc) as HareketliOrtalama
from Sales.SalesOrderHeader 
group by YEAR(OrderDate), MONTH(OrderDate)
