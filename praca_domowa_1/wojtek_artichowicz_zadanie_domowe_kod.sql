/*1 z którego kraju mamy najwięcej wniosków*/
SELECT kod_kraju,
       count(*)
FROM wnioski
GROUP BY kod_kraju
ORDER BY 2 DESC
LIMIT 2
-- Najwięcej wniosków jest z kraju o kodzie
-- ZZ - Kraj nieokreślony (N=67584)
-- IE - Irlandia (47737)


/*2 Z którego języka mamy najwięcej wniosków?*/
SELECT jezyk, count(*)
FROM wnioski
GROUP BY jezyk
ORDER BY 2 DESC
LIMIT 1
-- Najwięcej wniosków jest w jęcyku angielskim (N = 145134)


/*Ile % procent klientów podróżowało
w celach biznesowych a ilu w celach prywatnych?*/
with tab_typ_podrozy as (
    SELECT CASE
           WHEN typ_podrozy IS NULL
             THEN 'UNKNOWN'
           ELSE typ_podrozy
           END col_tp
    FROM wnioski
)

select col_tp typ,
       COUNT(col_tp) liczba_wnioskow,
       ROUND(count(col_tp) / SUM(COUNT(col_tp)) OVER ()::NUMERIC,4) procent_typu
FROM tab_typ_podrozy
GROUP BY col_tp
ORDER BY 1;
-- Większość klientów nie podała rodzaju podróży (168876,  94%). Z pozostałych
--


/*4) Jak procentowo rozkładają się źródła polecenia?*/
with tab_zp as (
    SELECT CASE
           WHEN zrodlo_polecenia IS NULL
             THEN 'UNKNOWN'
           ELSE zrodlo_polecenia
           END col_zp
    FROM wnioski
)

select col_zp,
       ROUND(count(col_zp) / SUM(COUNT(col_zp)) OVER ()::NUMERIC,4) procent_typu
from tab_zp
Group by col_zp;



/* 5 Ile podróży to trasy złożone z jednego / dwóch / trzech / więcej tras? */

-- utworz pomocnicza tabele zawierajaca zliczone pod-trasy w rozwazanej podrozy
-- sp.id_podrozy, p.id sa wypisane w celu kontroli poprawnosci zapytania
with tab_pod_tr as (
SELECT sp.id_podrozy
        ,p.id
       ,COUNT(*) col_liczba_tras
from podroze p
join szczegoly_podrozy sp ON p.id = sp.id_podrozy
GROUP BY p.id, sp.id_podrozy
),
-- utworz pomocnicza tabele zawierajaca zliczona liczbe podrozy w ktorych wystapila
-- dana liczba przesiadek Np.: Zadnej przesiadki (col_distinct_liczba_tras = 1) nie bylo w
-- trakcie 165532 podrozy*/
tab_liczba_podrozy as(
select col_liczba_tras col_distinct_liczba_tras, count( * ) col_liczba_podrozy
From tab_pod_tr
group by col_liczba_tras
order by 1)

-- posortuj powyzsze wyniki i wyswietl tylko 3 pierwsze
(select to_char(col_liczba_tras,'99') liczba_tras, count(*) liczba_podrozy
From tab_pod_tr
group by col_liczba_tras
order by 1
limit 3)
UNION ALL
-- a anstepnie zsumuj reszte i doklej do wyswietlanej tabeli
(select '>3', sum(col_liczba_podrozy)
from tab_liczba_podrozy
where col_distinct_liczba_tras > 3);


/* 6) Na które konto otrzymaliśmy najwięcej / najmniej rekompensaty (kwota rekompensat)?*/
with tab_kwota_rekompensat as(
    select konto,
           sum(kwota)
    from szczegoly_rekompensat
    group by konto)

(SELECT 'min' stat, *
From tab_kwota_rekompensat
order by 3 asc
limit 1)

UNION ALL

(SELECT 'max' stat, *
From tab_kwota_rekompensat
order by 3 desc
limit 1) ;


/*7) Który dzień jest rekordowym w firmie w kwestii utworzonych wniosków?*/
SELECT to_char(w.data_utworzenia,'YYYY-MM-DD') dni, count(*)
from wnioski w
GROUP BY dni
Order By 2 desc
LIMIT 1

/*8 Który dzień jest rekordowym w firmie w kwestii otrzymanych rekompensat??*/
SELECT to_char(r.data_zakonczenia,'YYYY-MM-DD') dni, count(*)
FROM rekompensaty r
GROUP BY dni
order by 2 desc
limit 3

/*9 Jaka jest dystrubucja tygodniowa wniosków według kanałów? (liczba wniosków w danym tygodniu w każdym kanale)?*/
SELECT to_char(data_utworzenia,'WW') tydzien,
       kanal,
       COUNT(*)
FROM wnioski
group by tydzien, kanal



/*10 Lista wniosków przeterminowanych (przeterminowany = utworzony w naszej firmie powyżej 3 lat od daty podróży)*/
SELECT  w.id,
        sp.data_wyjazdu,
        w.data_utworzenia::date,
        age(w.data_utworzenia::date, sp.data_wyjazdu) wiek_wniosku

FROM szczegoly_podrozy sp
JOIN podroze p ON p.id = sp.id_podrozy
JOIN wnioski w ON p.id_wniosku = w.id
where age(w.data_utworzenia::date, sp.data_wyjazdu) > '3 years'::interval
order by 1



-- Zadanie 2.2 (powracający klienci:
-- I.)  Badanie bazy danych pod kątem założenia, że tabela klientów jest unikalna tzn. rekordy klientów się nie powtarzają
--      i klienci sa przypisani do wniosków (jeden klient może miec wiele wniosków).

       SELECT 'liczba klientow = ' nazwa,
              COUNT(*)
       FROM klienci
       UNION ALL
         SELECT 'liczba wnioskow = ' nazwa,
                  COUNT(*)
          FROM klienci
              UNION ALL
                  SELECT 'klienci vs vnioski = ' nazwa,
                          COUNT(k.id)
                  FROM wnioski w
                  JOIN klienci k ON k.id_wniosku = w.id
                      UNION ALL
                          SELECT 'distinct wnioski by klienci= ' nazwa,
                          COUNT(DISTINCT w.id)
                          FROM klienci k
                          JOIN wnioski w ON k.id_wniosku = w.id
                              UNION ALL
                                 SELECT 'distinct klienci by wnioski = ' nazwa,
                                 COUNT(DISTINCT k.id_wniosku)
                                 FROM wnioski w
                                 JOIN klienci k ON k.id_wniosku = w.id
       --liczba wnioskiw = liczba klientow = join liczba wnioskow i klientow


    SELECT k.id
           ,count(k.id)
           ,count(w.id)
    FROM wnioski w
    JOIN klienci k ON k.id_wniosku = w.id
    GROUP BY k.id
    HAVING  count(k.id) > 1 OR count(w.id)>1 --z tą instrukcją dostaje się 0 rekordów, tzn k.id i w.id się nie powtarzają
        UNION ALL
            SELECT w.id
                  ,count(k.id)
                  ,count(w.id)
            FROM wnioski w
            JOIN klienci k ON k.id_wniosku = w.id
            GROUP BY w.id
            HAVING  count(k.id) > 1 OR count(w.id)>1 --z tą instrukcją dostaje się 0 rekordów, tzn k.id i w.id się nie powtarzają

--     WYNIK: To klienci sa przypisani wnioskom. Ponadto liczba wniosków i liczba klientów jest taka sama. Na każdy wniosek przypada
--            rekord w tabeli klienci. Rekrody kliebtów są dodawane razem z rekordami wniosków. W związku z tym jeśli jeden klient
--            złożył kilka wniosków, to w tabeli klienci będzie występował wielokrotnie.
--            Konieczne jest wyszukiwanie klientów po imionach i nazwiskach. Aby uniknąć scalenia klientów o identycznych danych
--            należy dodac jeszcze coś co ich różni z prawdopodobieństewem równym 1. Z braku unikatowego identyfikatora (np. PESEL)
--            użyty zostanie adres e-mail.



--zatem pozostaje sprawdzić klientów po imieniu i nazwisku i ewentualnie adresie e-mail*/
--Yay!!! Pewien klient występuje 618 razy. Trzeba sprawdzić czy to nie błąd i czy podpięte sa do niego różne wnioski
   --
-- odkomentowanie k.id_wniosku, spowoduje sprawdzenie czy jakiś (powracający) klient ma dwa takie same wnioski:
-- kwerenda (po odkomentowaniu) zwraca zero rekordów więc każdy wniosek klienta jest unikalny
select k.imie,
       k.nazwisko,
       k.email,
      --k.id_wniosku,
       count(*)
from klienci k
join wnioski w ON w.id = k.id_wniosku
group by k.imie, k.nazwisko, k.email--, k.id_wniosku
having count(*) > 1

-- ROZWIĄZANIE - obliczenie procenta powracających klientów bez uwzględniania faktu bycia współpasażerami
    --(wspolpasazerowie nie sa traktowani jako osobni klienci)

    -- wyszukanie klientow powracajacych, tj. takich, ktorzy zlozyli wiecej niz jeden wniosek,
    --czyli wystepuja w tabeli wiecej niz raz
    WITH tab_klienci_powracajacy AS (
    SELECT k.imie,
           k.nazwisko,
           k.email,
           COUNT(*) col_liczba_wnioskow
    FROM klienci k
    GROUP BY k.imie, k.nazwisko, k.email
    HAVING COUNT(*) > 1),

    --zliczenie liczby powracajacyh klientow
    tab_liczba_powracajacych_klientow AS (
    SELECT
        1 col_row_count,
        COUNT(*) col_liczba_powracajacych_klientow
    FROM tab_klienci_powracajacy
    ),

    --SELECT * FROM tab_liczba_powracajacych_klientow; --testing

    --obliczenie calkowitej liczby klientów (z odrzuceniem powtarzających się rekordów)
    tab_liczba_klientow AS (
    SELECT
        1 col_row_count,
        COUNT(DISTINCT  k.email) col_liczba_klientow
    FROM klienci k)

    -- obliczenie procentu (części) powracających klientów tj. jednego klienta
    -- bez uwzględniania osób bedących współpasażerami
    SELECT lpk.col_liczba_powracajacych_klientow liczba_powracajacych_klientow,
           lk.col_liczba_klientow liczba_wszystkich_klientow,
           ROUND(lpk.col_liczba_powracajacych_klientow / lk.col_liczba_klientow::NUMERIC,8) procent
    FROM tab_liczba_klientow lk
    JOIN tab_liczba_powracajacych_klientow lpk ON lpk.col_row_count = lk.col_row_count;

-- 2.3Jaka część naszych współpasażerów to osoby, które już wcześniej pojawiły się na jakimś wniosku?

    -- wspolpasazerowie, którzy pojawili się na innym wniosku jako wspolpasazerowie
    WITH tab_all_emails AS (
        WITH tab_multi_wspolpasazerowie AS (
            SELECT wp.email col_email,
            COUNT(wp.id_wniosku)
            FROM wspolpasazerowie wp
            GROUP BY wp.email
            HAVING COUNT(wp.id_wniosku)>1
       )
       SELECT col_email
       FROM tab_multi_wspolpasazerowie
       UNION --merge by email
       -- wspolpasazerowie, którzy pojawili się na innym wniosku jako klienci
       SELECT k.email
       FROM klienci k
       JOIN wspolpasazerowie wp ON wp.email = k.email
    ),

    tab_distinct_email_count as (
       SELECT
       1 col_row_number,
       COUNT(DISTINCT email)
       FROM wspolpasazerowie
    ),

    tab_all_emails_count as (
        SELECT
        1 col_row_number,
        COUNT(*)
        FROM tab_all_emails
    )

    SELECT taec.count liczba_wystapien,
           tdec.count liczba_wspolpasazerow,
           ROUND(taec.count/ tdec.count::NUMERIC,5) procent
    FROM tab_all_emails_count taec
    JOIN tab_distinct_email_count tdec ON tdec.col_row_number = taec.col_row_number;


/*Jaka część klientów pojawiła się na innych wnioskach jako współpasażer?*/
    --policzenie wszystkich klientow
    --policzenie wszystkich klientow
    with tab_liczba_klientow as(
         SELECT 1 col_row_number,
         count(distinct email) col_liczba
         FROM klienci
    ),

    -- select * from tab_liczba_klientow --check

    -- wyszukanie tych samych adresow e-mail w tabeli wspolpasazerowie
    tab_jako_wspolpasazerowie AS (
         SELECT 1 col_row_number,
         COUNT(DISTINCT k.email) col_liczba
         FROM klienci k
         JOIN wspolpasazerowie w ON k.email = w.email
    )

   -- select * from tab_jako_wspolpasazerowie --check

   SELECT jw.col_liczba,
          lk.col_liczba,
          ROUND(jw.col_liczba/lk.col_liczba::numeric,5) procent
   FROM tab_jako_wspolpasazerowie jw
   JOIN tab_liczba_klientow lk ON jw.col_row_number = lk.col_row_number

/* Czy jako nowy klient mający kilka zakłóceń, od razu składasz kilka wniosków?
   Jaki jest czas od złożenia pierwszego do kolejnego wniosku? */

-- zapytanie czy klienci w ogóle składają po kilka wniosków jednocześnie
    --zliczenie liczby wniosków składanych jednocześnie
    --posortowanie ich rosnąco względem emaili i czasu złożenia wniosku
    WITH tab_liczba_jednoczesnych_wnioskow_per_klient AS (
        SELECT k.email col_email,
            to_char(w.data_utworzenia,'YYYY-MM-DD') col_day,
            COUNT(w.id) col_liczba
         FROM klienci k
         JOIN wnioski w ON k.id_wniosku = w.id
         GROUP BY col_email, col_day
         ORDER BY col_email, col_day
    ),

    --SELECT * FROM tab_liczba_jednoczesnych_wnioskow_per_klient WHERE col_liczba >1 --check
    tab_interval_miedzy_wnioskami_per_klient AS (
    SELECT col_email col_email,
           to_date(col_day,'YYYY MM DD')-to_date(LAG(col_day) OVER (ORDER BY col_day),'YYYY MM DD') col_roznica,
           LAG(col_email) OVER (ORDER BY col_email) lag_email
    FROM tab_liczba_jednoczesnych_wnioskow_per_klient --check
    WHERE col_liczba > 1
   )


   SELECT col_email,
          MIN(col_roznica),
          ROUND(AVG(col_roznica),3) srednia_liczba_dni,
          MAX(col_roznica)
   FROM tab_interval_miedzy_wnioskami_per_klient
   WHERE col_email = lag_email
   GROUP BY col_email



    --D.1 Jako data scientist jesteś także zobowiązany/a do sprawdzania danych
    --pod kątem wyłudzeń (ten sam lot, ta sama osoba).
    -- Znajdź listę współpasażerów próbujących stworzyć własny odrębny wniosek
    --(na ten sam identifikator_podrozy), pomimo istnienia jako współpasażer na innym wniosku
