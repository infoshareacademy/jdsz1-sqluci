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
-- czy zaklocenie wyst?pi?o, rodzaj zak??cenia,
-- zale?no?? d?ugo?ci op??nienia od wybranych zmiennych
--  marka poci?gu / operator / data

-- wybranie operatora, kodu sprz?tu i statusu przyjazdu
  --niekt?re rekordy maj null w czas op??nienia
SELECT kod_operatora
      ,kod_sprzetu
      ,czas_opoznienia
      ,przylot_status
FROM tab_o_trasy_clean
--GROUP BY kod_operatora;

