CREATE TABLE gracze(
  Id serial PRIMARY KEY,
  Login character varying (100) NOT NULL,
  LevelGracza INTEGER NOT NULL,
  LokalizacjaGry CHARACTER VARYING (20) NOT NULL,
  DataUrodzenia DATE NOT NULL,
  Ekwipunek INTEGER
);

CREATE TABLE sesje_gry(
  Id serial PRIMARY KEY,
  GraczID INTEGER NOT NULL,
  LevelID INTEGER NOT NULL ,
  Serwer VARCHAR(255),
  DataWejscia TIMESTAMP,
  DataWyjscia TIMESTAMP,
  LiczbaPunktow INTEGER,
  ReleaseID INTEGER,
  LiczbaPunktowZabranychPrzezWrogaID INTEGER,
  FOREIGN KEY (GraczID) REFERENCES gracze
  FOREIGN KEY (ReleaseID) REFERENCES release
  FOREIGN KEY (LiczbaPunktowZabranychPrzezWrogaID) REFERENCES punkty_zabrane_przez_wroga
);

INSERT INTO gracze(Login, LevelGracza, LokalizacjaGry,DataUrodzenia,Ekwipunek)
    VALUES ('Gandalf', 1,'EU','2001-03-12',1 );

INSERT INTO gracze(Login, LevelGracza, LokalizacjaGry,DataUrodzenia,Ekwipunek)
    VALUES ('Pippin', 2,'NZ','1985-03-12',3 );


INSERT INTO sesje_gry(  GraczID, LevelID,  Serwer, DataWejscia,
                        DataWyjscia ,LiczbaPunktow, ReleaseID, LiczbaPunktowZabranychPrzezWrogaID)
    VALUES (1, 1,'RealLifeServ',
             TO_TIMESTAMP('2014-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
             TO_TIMESTAMP('2014-07-02 08:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
             200, 2, 3 );

INSERT INTO sesje_gry(  GraczID, LevelID,  Serwer, DataWejscia,
                        DataWyjscia ,LiczbaPunktow, ReleaseID, LiczbaPunktowZabranychPrzezWrogaID)
    VALUES (1, 1,'RealLifeServ',
             TO_TIMESTAMP('2014-07-02 09:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
             TO_TIMESTAMP('2014-07-02 11:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
             20, 12, 2 );

INSERT INTO sesje_gry(  GraczID, LevelID,  Serwer, DataWejscia,
                        DataWyjscia ,LiczbaPunktow, ReleaseID, LiczbaPunktowZabranychPrzezWrogaID)
    VALUES (2, 1,'RealLifeServ',
             TO_TIMESTAMP('2014-07-02 10:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
             TO_TIMESTAMP('2014-07-02 11:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
             20, 12, 2 );


SELECT gracze.Login, sesje_gry.DataWejscia, sesje_gry.DataWyjscia
FROM gracze
JOIN sesje_gry ON gracze.Id = sesje_gry.GraczID
ORDER BY sesje_gry.DataWejscia,sesje_gry.DataWyjscia;