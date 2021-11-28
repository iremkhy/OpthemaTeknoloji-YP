CREATE TABLE Ogrenci (
    OgrenciID int PRIMARY KEY not null,
    OgrenciAdý nvarchar(40),
	OgrenciMail Nvarchar(40) UNIQUE
)

CREATE TABLE Notlar (
	OgrenciID int FOREIGN KEY REFERENCES Ogrenci(OgrenciID) not null,
	DersKodu int DEFAULT 0 not null, 
    Vize tinyint CHECK (Vize <= 100),
    Final tinyint CHECK (Final <= 100)
)

-- Ayný ýd ile baþka birini eklemeye çalýþtým. 
--"Violation of PRIMARY KEY constraint 'PK__Ogrenci__E497E6D425AA49AA'. Cannot insert duplicate key in object 'dbo.Ogrenci'. The duplicate key value is (1)." hatasýný verdi.
INSERT INTO Ogrenci(OgrenciID, OgrenciAdý, OgrenciMail)
        VALUES(1, 'Alper', 'alper@hotmail.com')

-- Ayný maile sahip iki kiþi eklemeye çalýþtým 
--"Violation of UNIQUE KEY constraint 'UQ__Ogrenci__C7667DD124DD7F68'. Cannot insert duplicate key in object 'dbo.Ogrenci'. The duplicate key value is (irem@hotmail.com)." hatasýný verdi.
INSERT INTO Ogrenci(OgrenciID, OgrenciAdý, OgrenciMail)
        VALUES(1, 'Ýrem', 'irem@hotmail.com'),
			  (2, 'Ýpek', 'irem@hotmail.com')
-- Final notunu 100'den büyük bir sayý girdim. 
--"The INSERT statement conflicted with the CHECK constraint "CK__Notlar__Final__21D600EE". The conflict occurred in database "master", table "dbo.Notlar", column 'Final'." hatasýný verdi.
INSERT INTO Notlar(OgrenciID, DersKodu, Vize, Final)
        VALUES(1, 123, 50, 105),
				(1, 222, 50, 100)
-- DersKodunu boþ býraktým ama tabloda 0 olarak geldi.
INSERT INTO Notlar (OgrenciID, DersKodu, Vize, Final)
        VALUES(1, '', 50, 70)

-- Notlar tablosunda olan bir öðrenciyi silmeye çalýþtým. 
-- The DELETE statement conflicted with the REFERENCE constraint "FK__Notlar__OgrenciI__269AB60B". The conflict occurred in database "master", table "dbo.Notlar", column 'OgrenciID'. hatasýný verdi.
DELETE FROM Ogrenci 
WHERE OgrenciID = 1

select * from Notlar