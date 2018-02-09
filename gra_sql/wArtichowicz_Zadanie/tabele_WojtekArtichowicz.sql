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
  FOREIGN KEY (GraczID) REFERENCES gracze(id)
);
