-- VIEW
-- �al��anlar�n maa� hari� bilgileri
create view vwEmployeeInfo
as
select Name, Surname, PhoneNumber, StartDate
from dbo.Employee

select *
from dbo.vwEmployeeInfo

 
-- H�rriyet �ubesindeki hesaplar
create view vwBranchNamevAccount
as
select BranchName, AccountID
from Branches as b inner join Account as a
on b.BranchID = a.BranchID
where b.BranchID = 1

select *
from dbo.vwBranchNamevAccount
 
-- kullan�c�lar�n kullan�c� ad� ve hesaplar�
create view vwUserNamevAccount
as
select AccountID, UserName
from UserLoginDetails as uld full join AccountUserLogin as aul
on uld.UserID = aul.UserID

select *
from dbo.vwUserNamevAccount

-- STORED PROCUDERE
-- Girilen Kullan�c� ad�n�n �ifresini de�i�tir
create procedure spUserPasswordUpdate
(
@UserID int,
@NewPassword varchar(10)
)
as
begin
	select Username, Password
	from UserLoginDetails
	where UserID = @UserID

	update UserLoginDetails
	set Password = @NewPassword
	where UserID = @UserID

	select Username, Password
	from UserLoginDetails
	where UserID = @UserID
end

exec spUserPasswordUpdate 3, '22222222'

-- girilen hesab�n �ubesini g�ncelle
create procedure spUpdateBranch
(
@AccountID int,
@Branch int
)
as
begin
	update Account
	set BranchID = @Branch
	where AccountID = @AccountID
end

exec spUpdateBranch 1, 2

select AccountID, BranchID
from Account
where AccountID = 1

-- USER DEFINE FUNCTION
-- Y�ll�k faiz hesapla
create function fnCalculateYearInterest
(
@Amount decimal,
@InterestRate decimal,
@term int
)
returns decimal
as
begin
	return @InterestRate * @Amount * @term/100
end

select dbo.fnCalculateYearInterest(50000,0.5,1000)

-- girilen pozisyondaki en y�ksek maa�
create function fnTopSalarybyposition
(
@position int
)
returns decimal
as
begin
	return(SELECT top 1 Salary
        from Employee
        where @position = PositionID
order by Salary desc)
end

select dbo.fnTopSalarybyposition(1)
 
-- girilen m��terinin ka� tane hesab� var
create function fnCountAccount
(
@customerID int
)
returns decimal
as
begin
	return(SELECT count (AccountID)
        from CustomerAccount
        where @CustomerID= CustomerID)
end

select dbo.fnCountAccount(1)

-- TRIGGER
-- hesap silinirse silme aktif de�il yap
create trigger trgNotDeleteAcc
on Account
instead of delete
as
begin
	update a
	set a.AccountStatusTypeID = 2
	from Account as a inner join deleted as d
	on a.AccountID = d.AccountID
end

 
-- �ifre de�i�irse modifieddate de g�ncelle
create trigger trPasswordModifiedDate
on UserLoginDetails
after update
as 
begin
	update uld
	set uld.ModifiedDate = GETDATE()
	from UserLoginDetails as uld inner join deleted as d
	on uld.UserID = d.UserID
end

update UserLoginDetails
set Password = '20834578'
where UserID = 1

