-- wp?yw zmiennych na op??nienie
-- wyczyszczenie i wybranie danych
WITH tab_o_trasy_clean AS ( --wybranie unikalnych rekord?w w og?le
  SELECT DISTINCT *
  FROM ( --wybranie unikalnych rekord?w wzgl?dem kodu po??czenia
        SELECT DISTINCT ON (kod_polaczenia) *
        FROM o_trasy
  ) tab_o_trasy_pre_clean
  WHERE przylot_status != '' AND przylot_status != 'NS'  --odrzucam rekordy o statusie przylotu nieznanym
        AND NOT ( --te rekordy nie s? interesuj?ce, ale tu tylko czyszcz? dane
                   (wylot_status = 'CX' AND przylot_status != 'CX')
                OR (wylot_status != 'CX' AND przylot_status = 'CX')
                )
       AND przylot_status != 'CX' AND wylot_status != 'CX'
      -- AND przylot_status != 'DY' --check
)
--SELECT * FROM tab_o_trasy_clean; --check

-- BADANE ZMIENNE
-- zale?no?? d?ugo?ci op??nienia od wybranych zmiennych
--  marka poci?gu / operator / data

-- wybranie operatora, kodu sprz?tu i statusu przyjazdu
  --niekt?re rekordy maj null w czas op??nienia - zastąpione obliczonym opóxnieniem
SELECT tc.kod_operatora
      ,tc.kod_sprzetu
      ,tc.przylot_status
      ,to_char(tc.plan_odjazd_dataczas,'YYYY-MM-DD HH:MI') plan_odjazd
      ,to_char(tc.plan_przyjazd_dataczas,'YYYY-MM-DD HH:MI') plan_przyjazd
      ,to_char(tc.real_odjazd,'YYYY-MM-DD HH:MI') real_odjazd
      ,to_char(tc.real_przyjazd,'YYYY-MM-DD HH:MI') real_przyjazd
      ,coalesce(tc.czas_opoznienia,EXTRACT(EPOCH FROM tc.real_przyjazd - tc.plan_przyjazd_dataczas)/60) czas_opoznienia_przyjazd_mi
      ,tc.wylot_kod_regionu
      ,tc.przylot_kod_regionu
      ,tc.wylot_nazwa_kraju
      ,tc.przylot_nazwa_kraju
      ,tc.wylot_nazwa
      ,tc.przylot_nazwa
FROM tab_o_trasy_clean tc
WHERE tc.czas_opoznienia >= 180

--WSTĘPNA ANALIZA
--https://public.tableau.com/profile/wojciech.artichowicz#!/vizhome/JDSZ1SU-21/oprator_sprzet_general_view?publish=yes

-- NIE MA SENSU BADAĆ LICZBY (PRPOPORCJI) OPÓŹNIONYCH/NIEOPÓŹNIONYCH BO INFORMACJI O TYCH DRUGICH JEST BARDZO MAŁO
-- WARTO ZBADAĆ ZALEŻNOŚĆ DŁUGOŚCI OPÓŹNIENIA OD MARKI POCIĄGU, OPERATORA I DATY

--dane dotyczące tras nie muszą mieć odpowiedników we wnioskach
--później sprawdzić czy dla tych tras, które figurują we wnioskach cos zależy
--od zakłócenia, strajku itp.

--JOIN analizy_wnioskow aw ON aw.id_wniosku = tc - żeby sprawdzić czy

--GROUP BY kod_operatora;


-- UWAGI, WNIOSKI:
/*

*/

SELECT *
FROM o_trasy;