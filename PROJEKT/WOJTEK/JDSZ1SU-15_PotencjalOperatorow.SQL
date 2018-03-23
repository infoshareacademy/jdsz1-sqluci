/*
JDSZ1SU-15: Jaki jest potencjał poszczególnych operatorów?
Ile pociągów jest opóźnionych / anulowanych i jaka jest
całkowita wartość rekompensaty?

--INFORMACJE DODATKOWE
Dane do analizy znajdują się w tabeli trasy
CX = cancelled
DY = delayed
EY = wcześniej
OT = on time
NS = nie wiadomo
NULL = brak informacji

Dwie pierwsze litery nazwy operatora są zawarte w kodzie połcenia
(zwróć uwagę na wielkosć liter)
SELECT DISTINCT lower(substring(kod_polaczenia,1,2))
FROM o_trasy;

SELECT DISTINCT lower(substring(nazwa,1,2))
FROM o_operatorzy;
*/

--Podgląd całej tabeli o_trasy
SELECT *
FROM o_trasy;

--Podgląd całej tabeli o_operatorzy
SELECT *
FROM o_operatorzy;

--Podgląd unikatowych kodów operatorów realizujących połączenie
SELECT DISTINCT upper(substring(kod_polaczenia,1,2))
FROM o_trasy;

--Podgląd unikatowych kodów operatorów z tabeli o_operatorzy
SELECT DISTINCT upper(substring(nazwa,1,2))
FROM o_operatorzy;

/*
 Tabela zawierająca nazwy i koedy operaotrów jest niekohenena z tabelą trasy
 niektórych operatorów nie da się zidentyfikować po kodzie trasy
EX
IN
KO
TL

vs.

EIC	EiC
TLK	TLK
KPO	Koleje pomorskie
KML	Koleje malopolskie
KKU	Koleje kujawskie
KLU	Koleje lubelskie
KSL	Koleje slaskie
KWI	Koleje wielkopolskie
KMA	Koleje mazowieckie

W dalszym ciągu opieram się tylko na dwóch pierwszych literach kodu trasy.
*/

--Podgląd unikatowych kodów operatorów realizujących połączenie
SELECT DISTINCT upper(substring(kod_polaczenia,1,2))
FROM o_trasy;

--sprawdzenie czy gdzieś występuje sytuacja, ze wylot nie jest odwołany
-- a przylot jest odwołany (cokolwiek by to mogło oznaczać!?)
-- TO JEST PRAWDOPODOBNY BŁĄD W DANYCH - należy odrzucić te dane
-- tych danych jest mało
SELECT wylot_status, przylot_status
FROM o_trasy
WHERE wylot_status != przylot_status AND przylot_status = 'CX';

SELECT wylot_status, przylot_status,COUNT(*)
FROM o_trasy
GROUP BY 1,2
ORDER BY 3 DESC;


-- Rekordy tras są zduplikowane, w celu użycia danych nalezy wybrać unikalne rekordy
SELECT kod_polaczenia, COUNT(1)
FROM o_trasy
GROUP BY kod_polaczenia
HAVING COUNT(1)>1
ORDER BY 1 DESC;

-- sprawdzenie czy rekordy są zduplikowane w całości, czy
-- są zduplikowane tylko ich elementy
SELECT 'distinct kody', COUNT(DISTINCT kod_polaczenia)
FROM o_trasy
UNION ALL
SELECT 'distinct rekordy', COUNT(*)
FROM (SELECT DISTINCT * FROM o_trasy) dist;
-- WNIOSEK: liczba unikalnych kodów i unikalnych rekordów różni się
-- zatem wybieram unikalne rekordy a z nich tylko te, z których nie powtarzają się
-- kody tras


SELECT DISTINCT kod_polaczenia, COUNT(1)
FROM o_trasy
GROUP BY kod_polaczenia;
/*
Tabela, z której usunięto nieprawidłowe dane tzn.:
 - rekordy, w których wylot jest odwołany (CX) a przylot ma inną wartość
 - rekordy, w których przylot jest odwołany (CX) a wylot nie
Ponadto usunięto rekordy, które nie są unikalne (DISTINCT), zarówno pod względem
kodu podróży jak i rekordów w całości.
 */

WITH tab_o_trasy_clean AS ( --wybranie unikalnych rekordów w ogóle
    SELECT DISTINCT *
      --wylot_status,
      --przylot_status
    FROM ( --wybranie unikalnych rekordów względem kodu połączenia
          SELECT DISTINCT ON (kod_polaczenia) *
          FROM o_trasy
    ) tab_o_trasy_pre_clean
    WHERE NOT (
               (wylot_status = 'CX' AND przylot_status != 'CX')
                OR (wylot_status != 'CX' AND przylot_status = 'CX')
              )
)
/*
-- po aktualizacji tabeli trasy o kod operatora zaczynam operować
--kodem operatora a nie wyłuskanymi literami z kodu połączenia
SELECT upper(substring(kod_polaczenia,1,2)),
       przylot_status,
       COUNT(*)
FROM tab_o_trasy_clean
GROUP BY 1, 2;
*/


SELECT o.nazwa,
       CASE
          WHEN tc.przylot_status IN ('EY','OT','CX','DY','NS') THEN  tc.przylot_status
          ELSE 'UN'
        END,
       COUNT(*) liczba_tras,
       SUM(tc.rekompensata) suma_rekompensaty,
       ROUND(AVG(tc.rekompensata),1) sr_rekompensata,
       to_char(plan_odjazd_data,'YYYY-MM-DD')
FROM tab_o_trasy_clean tc
JOIN o_operatorzy o ON o.kod = tc.kod_operatora
--WHERE tc.czy_uprawniony = TRUE
GROUP BY 1, 2, 6
ORDER BY 1, 2, 6;


SELECT o.nazwa,
       CASE
          WHEN tc.przylot_status IN ('EY','OT','CX','DY','NS') THEN  tc.przylot_status
          ELSE 'UN'
        END,
       tc.rekompensata suma_rekompensaty,
       to_char(plan_odjazd_data,'YYYY-MM-DD')
FROM tab_o_trasy_clean tc
JOIN o_operatorzy o ON o.kod = tc.kod_operatora
-- WHERE tc.czy_uprawniony = TRUE;

