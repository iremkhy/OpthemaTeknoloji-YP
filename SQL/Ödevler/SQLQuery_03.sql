
-- Kisilerin Adi, Soyadi, Emailadresi, Telefonu, Adres bilgileri gelsin
select top 1* from Person.Person
select top 1* from Person.PersonPhone
select top 1* from Person.EmailAddress
select top 1* from Person.Address
select top 1* from Person.BusinessEntityAddress

select p.FirstName, p.LastName, ea.EmailAddress, pp.PhoneNumber, a.AddressLine1
from Person.Person as p inner join Person.PersonPhone pp
on p.BusinessEntityID = pp.BusinessEntityID
inner join Person.EmailAddress as ea
on ea.BusinessEntityID = p.BusinessEntityID
inner join Person.BusinessEntityAddress as bea
on bea.BusinessEntityID = ea.BusinessEntityID
inner join Person.Address as a
on a.AddressID = bea.AddressID

-- Tarihteki saatlere dikkat ederek gelsin
select *
from Sales.SalesOrderHeader
where OrderDate =
(
select max(OrderDate)
from Sales.SalesOrderHeader
where Orderdate >= '2014-06-30 00:00:00.000' and Orderdate < '2014-07-01 00:00:00.000'
)

-- Hic siparis vermemis musteriler (en az 3 farkli yontemle)
select * from Sales.customer
select * from Sales.SalesOrderHeader

select CustomerID
from Sales.Customer
where CustomerID not in
(
	select CustomerID
	from Sales.SalesOrderHeader
)

-- 2. yontem
select c.CustomerID
from Sales.Customer as c  left join sales.SalesOrderHeader as soh
on c.CustomerID = soh.CustomerID
where SalesOrderID is null

-- 3. yontem
select c.CustomerID
from Sales.Customer as c  left join sales.SalesOrderHeader as soh
on c.CustomerID = soh.CustomerID
group by c.CustomerID, SalesOrderID
having SalesOrderID is null

-- 4. yontem
SELECT CustomerID
FROM Sales.Customer as c
WHERE NOT EXISTS (
SELECT soh.CustomerID
FROM Sales.SalesOrderHeader as soh
WHERE soh.CustomerID = c.CustomerID)