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