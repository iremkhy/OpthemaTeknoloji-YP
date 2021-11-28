--	111-111-1111 Formatýnda olup sadece rakamlardan oluþan aramayý like’la nasýl yaparýz
select *
from Person.PersonPhone
where PhoneNumber like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'

--	Metnin içerisinde % ve _ ile arama yaparken metinde % karakteri geçiyorsa içinde % geçen kelimeleri nasýl buluruz
select *
from Production.Product
where name like '%[%]%'

-- 2. yontem (kaçýþ karakteri tanýmlama)
select *
from Production.Product
where name like '%\%%' escape '\'

--	Bir select yaz renkleri Türkçe getir
select Color,
	case when color = 'black' then 'siyah'
		 when Color = 'blue' then 'mavi'
		 when color = 'grey' then 'gri'
		 when color = 'multi' then N'Çok renkli'
		 when color = 'red' then N'kýrmýzý'
		 when color = 'silver' then N'gümüþ'
		 when color = 'silver/black' then N'gümüþ/siyah'
		 when color = 'white' then 'beyaz'
		 when color = 'yellow' then N'sarý'
	else N'boþ' 
	end as Renk
from Production.Product

--	Ürünleri renge göre a-z sýrada getirin ama null’lar son sýrada gelsin
select Color
from Production.Product
order by  	
case when Color IS NULL then 1 else 0 
end, Color

--	Fiyatý en pahalý 2. 20 adet (21-40) ürünü getirin
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

--  Yil ara toplamlari, aylýk ara toplamlar ve genel toplam
select year(OrderDate) as yýl, MONTH(OrderDate) as ay, sum(SubTotal) as ciro
from Sales.SalesOrderHeader
group by cube(year(OrderDate), MONTH(OrderDate))
order by yýl desc, ay asc
