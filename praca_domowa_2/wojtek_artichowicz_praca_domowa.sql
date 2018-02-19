-- 1) Jaka data była 8 dni temu?
SELECT (NOW() - '8 days'::INTERVAL)::DATE;

-- 2) Jaki dzień tygodnia był 3 miesiące temu?
SELECT to_char(NOW() - '3 months'::INTERVAL,'Day');

-- 3) W którym tygodniu roku jest 01 stycznia 2017?
SELECT to_char('2017-01-01'::date,'WW');

-- 4) Podaj listę wniosków z właściwym operatorem (który rzeczywiście przeprowadził trasę)
SELECT p.id_wniosku,
       --zamiana wartości null na operatora sprzedającego
       coalesce(sp.identyfikator_operator_operujacego,sp.identyfikator_operatora)
FROM wnioski w
JOIN podroze p ON p.id_wniosku = w.id
JOIN szczegoly_podrozy sp ON sp.id_podrozy = p.id;

-- 5) Przygotuj listę klientów z datą utworzenia ich pierwszego i drugiego wniosku. 3 kolumny: email, data 1wszego wniosku, data 2giego wniosku
SELECT DISTINCT k.email,
       first_value(w.data_utworzenia) over (PARTITION BY  k.email ORDER BY w.data_utworzenia) data_pierwszego_wniosku,
       nth_value(w.data_utworzenia,2) over (PARTITION BY k.email ORDER BY w.data_utworzenia ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) data_drugiego_wniosku
FROM klienci k
JOIN wnioski w ON w.id = k.id_wniosku
--WHERE k.email = 'kl_email1231344@ids.com' --check tylko ten się powtarza
GROUP BY k.email, w.data_utworzenia
ORDER BY 1,2


-- 6) Używając pełen kod do predykcji wniosków, zmień go tak aby uwzględnić kampanię marketingową,
-- która odbędzie się 26 lutego - przewidywana liczba wniosków z niej to 1000

-- wracamy do generowania sztucznych dat
with moje_daty as (select -- to jest odpowiedzialne za wygenerowanie dat z przyszlosci
  generate_series(
      date_trunc('day', '2018-01-20'::date), -- jaki jest pierwszy dzien generowania
      date_trunc('month', now())+interval '1 month'-interval '1 day', -- koncowy dzien generowania
      '1 day')::date as wygenerowana_data --interwał, co ile dni/miesiecy/tygodni dodawac kolejne rekordy
  ),
aktualne_wnioski as ( -- to jest kawalek odpowiedzialny za aktualna liczba wnioskow
    select to_char(data_utworzenia, 'YYYY-MM-DD')::date data_wniosku, count(1) liczba_wnioskow
    from wnioski
    group by 1
  ),
lista_z_wnioskami as (
    select md.wygenerowana_data, -- dla danej daty
      coalesce(aw.liczba_wnioskow,0) liczba_wnioskow, -- powiedz ile bylo wnioskow w danym dniu, jesli byl NULL dodajemy coalesce
      sum(aw.liczba_wnioskow) over(order by md.wygenerowana_data) skumulowana_liczba_wnioskow -- laczna liczba wnioskow dzien po dniu
    from moje_daty md
    left join aktualne_wnioski aw on aw.data_wniosku = md.wygenerowana_data --left join dlatego, ze niektore dni nie maja jeszcze wnioskow. wlasnie dla nich bede robil predykcje
    order by 1),
statystyki_dnia as (
    select to_char(wygenerowana_data, 'Day') dzien, round(avg(liczba_wnioskow)) przew_liczba_wnioskow -- round aby nie uzupelniac liczbami zmiennoprzecinkowymi
    from lista_z_wnioskami
      where wygenerowana_data <= '2018-02-09'
    group by 1
    order by 1
    )
select lw.wygenerowana_data, liczba_wnioskow, przew_liczba_wnioskow,
  case
    when wygenerowana_data <= '2018-02-09' then liczba_wnioskow
    when wygenerowana_data = '2018-02-26' then 1000 --kampania marketingowa
    else przew_liczba_wnioskow end finalna_liczba_wnioskow, -- dodaje case aby wybrac realna liczbe albo przewidywana w zaleznosci od daty

  sum(case
    when wygenerowana_data <= '2018-02-09' then liczba_wnioskow
    when wygenerowana_data = '2018-02-26' then 1000 --kampania marketingowa
    else przew_liczba_wnioskow end) over(order by wygenerowana_data) skumulowana_z_predykcja -- dodaje funkcje okna aby zsumowac wartosci zarowo realne jak i predykcje
from lista_z_wnioskami lw
join statystyki_dnia sd on sd.dzien = to_char(lw.wygenerowana_data, 'Day')
;

-- 7) Używając pełen kod do predykcji wniosków, zmień go tak aby uwzględnić przymusową przerwę serwisową,
-- w sobotę 24 lutego nie będzie można utworzyć żadnych wniosków

-- wracamy do generowania sztucznych dat
with moje_daty as (select -- to jest odpowiedzialne za wygenerowanie dat z przyszlosci
  generate_series(
      date_trunc('day', '2018-01-20'::date), -- jaki jest pierwszy dzien generowania
      date_trunc('month', now())+interval '1 month'-interval '1 day', -- koncowy dzien generowania
      '1 day')::date as wygenerowana_data --interwał, co ile dni/miesiecy/tygodni dodawac kolejne rekordy
  ),
aktualne_wnioski as ( -- to jest kawalek odpowiedzialny za aktualna liczba wnioskow
    select to_char(data_utworzenia, 'YYYY-MM-DD')::date data_wniosku, count(1) liczba_wnioskow
    from wnioski
    group by 1
  ),
lista_z_wnioskami as (
    select md.wygenerowana_data, -- dla danej daty
      coalesce(aw.liczba_wnioskow,0) liczba_wnioskow, -- powiedz ile bylo wnioskow w danym dniu, jesli byl NULL dodajemy coalesce
      sum(aw.liczba_wnioskow) over(order by md.wygenerowana_data) skumulowana_liczba_wnioskow -- laczna liczba wnioskow dzien po dniu
    from moje_daty md
    left join aktualne_wnioski aw on aw.data_wniosku = md.wygenerowana_data --left join dlatego, ze niektore dni nie maja jeszcze wnioskow. wlasnie dla nich bede robil predykcje
    order by 1),
statystyki_dnia as (
    select to_char(wygenerowana_data, 'Day') dzien, round(avg(liczba_wnioskow)) przew_liczba_wnioskow -- round aby nie uzupelniac liczbami zmiennoprzecinkowymi
    from lista_z_wnioskami
      where wygenerowana_data <= '2018-02-09'
    group by 1
    order by 1
    )
select lw.wygenerowana_data, liczba_wnioskow, przew_liczba_wnioskow,
  case
    when wygenerowana_data <= '2018-02-09' then liczba_wnioskow
    when wygenerowana_data = '2018-02-24' then 0 -- przerwa serwisowa
    else przew_liczba_wnioskow end finalna_liczba_wnioskow, -- dodaje case aby wybrac realna liczbe albo przewidywana w zaleznosci od daty

  sum(case
    when wygenerowana_data <= '2018-02-09' then liczba_wnioskow
    when wygenerowana_data = '2018-02-24' then 0 -- przerwa serwisowa
    else przew_liczba_wnioskow end) over(order by wygenerowana_data) skumulowana_z_predykcja -- dodaje funkcje okna aby zsumowac wartosci zarowo realne jak i predykcje
from lista_z_wnioskami lw
join statystyki_dnia sd on sd.dzien = to_char(lw.wygenerowana_data, 'Day')
;

-- 8) Ile (liczbowo) wniosków zostało utworzonych poniżej mediany liczonej z czasu między
-- NALEZY OKREŚLIC CZYM JEST CZAS LOTU

-- sprawdzenie czy daty się zgadzają
SELECT   sp.data_wyjazdu, ot.real_odjazd, ot.plan_odjazd_data,
         sp.data_wyjazdu = ot.plan_odjazd_data
FROM o_trasy ot
JOIN szczegoly_podrozy sp ON sp.identyfikator_podrozy = ot.kod_polaczenia --okreslenie podrozy na podstawie realizacji trasy po kodzie połączenia
WHERE (NOT (  -- usuniecie nieprawidlowych rekordow
             (ot.wylot_status = 'CX' AND ot.przylot_status != 'CX')
              OR (ot.wylot_status != 'CX' AND ot.przylot_status = 'CX')
            ) ) AND  sp.identyfikator_podrozy != 'TL----'
            AND sp.data_wyjazdu != ot.plan_odjazd_data;
--  generalnie daty się zgadzają. Jeśli się różnią to o jeen dzień do przodu. Przyjmuję założenieć, ze podróż rozpoczynała się
--  późnym wieczorem i z powodu opóźnienia zaczeła się kolejnego dnia wczesnym rankiem


-- JESLI LOT SIE ODBYŁ TO BĘDZIE TO CZAS OD JEGO ZAKOŃCZENIA DO ZŁOŻENIA WNIOSKU (TYLKO DLA LOTÓW OPÓŹNIONYCH)
-- JEŚLI LOT ZOSTAŁ ODWOŁANY TO BĘDZIE TO CZAS WYJAZDU
WITH tab_czasy_do_utworzenia_wniosku AS (
    SELECT  w.data_utworzenia - CASE --roznica w czasie zlozenia wniosku od czasu wystapienia zaklocenia
                                 WHEN ot.przylot_status = 'CX'
                                   THEN ot.plan_odjazd_data
                                 WHEN ot.przylot_status = 'DY'
                                   THEN ot.real_przyjazd
                                 END col_czas
    FROM o_trasy ot
      JOIN szczegoly_podrozy sp ON sp.identyfikator_podrozy = ot.kod_polaczenia
      --okreslenie podrozy na podstawie realizacji trasy po kodzie połączenia
      JOIN podroze p ON sp.id_podrozy = p.id
      JOIN wnioski w ON p.id_wniosku = w.id
    WHERE (NOT (-- usuniecie nieprawidlowych rekordow
      (ot.wylot_status = 'CX' AND ot.przylot_status != 'CX')
      OR (ot.wylot_status != 'CX' AND ot.przylot_status = 'CX')
    )) AND sp.identyfikator_podrozy != 'TL----'
),
-- SELECT * FROM tab_czasy_do_utworzenia_wniosku; --check
tab_mediana_czasu AS (
SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY col_czas) wartosc
FROM tab_czasy_do_utworzenia_wniosku
)

 SELECT * FROM tab_mediana_czasu; --check

;

