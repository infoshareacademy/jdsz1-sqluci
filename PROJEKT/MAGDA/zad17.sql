-- Czy istnieje sezonowość w opóźnieniach pociągów?

select  plan_odjazd_dataczas::date as data_podrozy,
  round(count(case when czas_opoznienia > 1 then 1 end)/count(1)::Numeric,4) procent_opoznionych
from o_trasy
group by 1
ORDER BY 1

