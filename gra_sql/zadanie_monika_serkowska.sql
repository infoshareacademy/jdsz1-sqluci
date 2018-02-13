-- utworzenie tabeli 'items'

create TABLE items (
id SERIAL PRIMARY KEY,
typ_wroga text,
 opis text);

-- dodanie danych do tabeli 'items'

insert into items (typ_wroga, opis)
   VALUES ('samolot', 'bombowiec');

insert into items (typ_wroga, opis)
   VALUES ('czolg', 'tygrys');

insert into items (typ_wroga, opis)
   VALUES ('samolot', 'myśliwiec');

insert into items (typ_wroga, opis)
   VALUES ('samolot', 'myśliwsko-bombowy');

-- utworzenie tabeli 'punkty zebrane przez wroga'

create TABLE punktyzebraneprzezwroga (
 id SERIAL PRIMARY KEY,
 typ_wroga text,
 liczba_punkt integer,
   foreign key (id) references items);

-- dodanie danych do tabeli 'punkty zebrane przez wroga'

insert into punktyzebraneprzezwroga (typ_wroga, liczba_punkt)
   VALUES ('samolot', '100');

insert into punktyzebraneprzezwroga (typ_wroga, liczba_punkt)
   VALUES ('czolg', '50');

-- zadanie  1) lista itemów i zabranych punktów

select items.typ_wroga, sum(liczba_punkt) from items
  inner join punktyzebraneprzezwroga
    ON items.typ_wroga = punktyzebraneprzezwroga.typ_wroga
GROUP BY items.typ_wroga;


-- zadanie 2) lista itemów i suma zebranych przez nich punktów posortowana od najlepszego itema

select items.typ_wroga, sum(liczba_punkt) from items
  inner join punktyzebraneprzezwroga
    ON items.typ_wroga = punktyzebraneprzezwroga.typ_wroga
GROUP BY items.typ_wroga
ORDER BY sum(liczba_punkt) DESC;

-- zadanie 3) lista itemów które zebrały mniej niż 5 punktów łącznie

select items.typ_wroga, sum(liczba_punkt) as SUM from items
  inner join punktyzebraneprzezwroga
    ON items.typ_wroga = punktyzebraneprzezwroga.typ_wroga
  GROUP BY items.typ_wroga
HAVING sum(liczba_punkt) < 5;

-- zadanie 4) lista itemów typu samolot, które zabierały punkty od wroga więcej niż 10 razy

select items.typ_wroga from items
  where typ_wroga = 'samolot'
  GROUP BY items.typ_wroga
  HAVING count(*) > 10;


