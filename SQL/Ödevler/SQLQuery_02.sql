--	111-111-1111 Format�nda olup sadece rakamlardan olu�an aramay� like�la nas�l yapar�z
select *
from Person.PersonPhone
where PhoneNumber like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'

--	Metnin i�erisinde % ve _ ile arama yaparken metinde % karakteri ge�iyorsa i�inde % ge�en kelimeleri nas�l buluruz
select *
from Production.Product
where name like '%[%]%'

-- 2. yontem (ka��� karakteri tan�mlama)
select *
from Production.Product
where name like '%\%%' escape '\'

--	Bir select yaz renkleri T�rk�e getir
select Color,
	case when color = 'black' then 'siyah'
		 when Color = 'blue' then 'mavi'
		 when color = 'grey' then 'gri'
		 when color = 'multi' then N'�ok renkli'
		 when color = 'red' then N'k�rm�z�'
		 when color = 'silver' then N'g�m��'
		 when color = 'silver/black' then N'g�m��/siyah'
		 when color = 'white' then 'beyaz'
		 when color = 'yellow' then N'sar�'
	else N'bo�' 
	end as Renk
from Production.Product

--	�r�nleri renge g�re a-z s�rada getirin ama null�lar son s�rada gelsin
select Color
from Production.Product
order by  	
case when Color IS NULL then 1 else 0 
end, Color

--	Fiyat� en pahal� 2. 20 adet (21-40) �r�n� getirin
select name
from Production.Product
order by ListPrice desc
OFFSET 20 ROWS FETCH NEXT 20 ROWS ONLY;

--	Tek bir siparisi en az 50 bin TL olup, toplam siparis tutari 500 bin TL den fazla olan musteriler
select CustomerID
from Sales.SalesOrderHeader
where SubTotal > 50000
group by CustomerID
having sum(SubTotal) > 500000

--  Yil ara toplamlari, ayl�k ara toplamlar ve genel toplam
select year(OrderDate) as y�l, MONTH(OrderDate) as ay, sum(SubTotal) as ciro
from Sales.SalesOrderHeader
group by cube(year(OrderDate), MONTH(OrderDate))
order by y�l desc, ay asc
