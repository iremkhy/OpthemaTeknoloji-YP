CREATE TABLE Ogrenci (
    OgrenciID int PRIMARY KEY not null,
    OgrenciAd� nvarchar(40),
	OgrenciMail Nvarchar(40) UNIQUE
)

CREATE TABLE Notlar (
	OgrenciID int FOREIGN KEY REFERENCES Ogrenci(OgrenciID) not null,
	DersKodu int DEFAULT 0 not null, 
    Vize tinyint CHECK (Vize <= 100),
    Final tinyint CHECK (Final <= 100)
)

-- Ayn� �d ile ba�ka birini eklemeye �al��t�m. 
--"Violation of PRIMARY KEY constraint 'PK__Ogrenci__E497E6D425AA49AA'. Cannot insert duplicate key in object 'dbo.Ogrenci'. The duplicate key value is (1)." hatas�n� verdi.
INSERT INTO Ogrenci(OgrenciID, OgrenciAd�, OgrenciMail)
        VALUES(1, 'Alper', 'alper@hotmail.com')

-- Ayn� maile sahip iki ki�i eklemeye �al��t�m 
--"Violation of UNIQUE KEY constraint 'UQ__Ogrenci__C7667DD124DD7F68'. Cannot insert duplicate key in object 'dbo.Ogrenci'. The duplicate key value is (irem@hotmail.com)." hatas�n� verdi.
INSERT INTO Ogrenci(OgrenciID, OgrenciAd�, OgrenciMail)
        VALUES(1, '�rem', 'irem@hotmail.com'),
			  (2, '�pek', 'irem@hotmail.com')
-- Final notunu 100'den b�y�k bir say� girdim. 
--"The INSERT statement conflicted with the CHECK constraint "CK__Notlar__Final__21D600EE". The conflict occurred in database "master", table "dbo.Notlar", column 'Final'." hatas�n� verdi.
INSERT INTO Notlar(OgrenciID, DersKodu, Vize, Final)
        VALUES(1, 123, 50, 105),
				(1, 222, 50, 100)
-- DersKodunu bo� b�rakt�m ama tabloda 0 olarak geldi.
INSERT INTO Notlar (OgrenciID, DersKodu, Vize, Final)
        VALUES(1, '', 50, 70)

-- Notlar tablosunda olan bir ��renciyi silmeye �al��t�m. 
-- The DELETE statement conflicted with the REFERENCE constraint "FK__Notlar__OgrenciI__269AB60B". The conflict occurred in database "master", table "dbo.Notlar", column 'OgrenciID'. hatas�n� verdi.
DELETE FROM Ogrenci 
WHERE OgrenciID = 1

select * from Notlar