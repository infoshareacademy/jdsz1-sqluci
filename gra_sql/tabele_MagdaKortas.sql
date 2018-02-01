create table rynek2 (
  Id_rynek serial primary key,
  kraj text,
  region text,
  jezyk text,
  wartosc INTEGER);

create table release3 (
  id_release serial PRIMARY KEY,
  opis text,
  datarel date,
  funcjonalnosc text);

create table rynki4_release (
  id_rynek_release serial PRIMARY KEY,
  data date,
  id_rynek INTEGER,
  id_release INTEGER,
  FOREIGN KEY (id_rynek) REFERENCES rynek2,
  FOREIGN KEY (id_release) REFERENCES release3);

insert into rynek2 (kraj, region, jezyk, wartosc) values ('Bhutan', 'Asia', 'Bhutanese', 5000);
insert into rynek2 (kraj, region, jezyk, wartosc) values ('Costa Rica', 'Americas', 'Spanish', 3000);

insert into release3 (opis, datarel, funcjonalnosc) values ('blabla1', '01/05/2016', 'flying');
insert into release3 (opis, datarel, funcjonalnosc) values ('blabla2', '02/06/2015', 'swimming');

insert into rynki4_release (data, id_rynek, id_release) values ('05/06/2011', 1, 2);
insert into rynki4_release (data, id_rynek, id_release) values ('05/06/2012', 2, 1);

SELECT r.region, r.kraj, r3.funcjonalnosc, rynki4_release.data
FROM rynki4_release
JOIN rynek2 r ON rynki4_release.id_rynek = r.Id_rynek
JOIN release3 r3 ON rynki4_release.id_release = r3.id_release;
