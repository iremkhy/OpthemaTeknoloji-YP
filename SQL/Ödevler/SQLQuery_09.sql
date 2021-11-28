select *
from Production.Location

create table dbo.Musteri
(
MusteriID bigint not null primary key identity(1,1),
Ýsim nvarchar(30),
TelefonNumarasi varchar(20)
)

select * from dbo.Musteri

insert into dbo.Musteri(Ýsim, TelefonNumarasi)
values('Ýrem', 05399174756),
		('Ýpek', 05399185858),
		('Alper', 05457898787)

ALTER TABLE dbo.Musteri
ALTER COLUMN TelefonNumarasi VARCHAR(20) MASKED WITH (FUNCTION = 'partial(0,"XXXXXXX",4)')

CREATE USER TestUser WITHOUT LOGIN;
GRANT SELECT ON dbo.Musteri to TestUser;

EXECUTE AS user = 'TestUser'
SELECT * FROM Musteri
REVERT
