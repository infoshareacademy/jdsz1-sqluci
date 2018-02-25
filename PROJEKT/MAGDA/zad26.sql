
select wylot_kod || '-' || przylot_kod as trasa,
  count(case when czas_opoznienia >= 15 then 1 end) opoznione,
  count(1) wszystkie,
  count(case when czas_opoznienia >= 15 then 1 end)/count(1)::NUMERIC ile_razy_opoznione15 -- Lista najczęściej zakłóconych: opóźnionych 15min
from o_trasy
GROUP BY 1
  having count(1) > 500
ORDER BY 4 DESC;

select wylot_kod || '-' || przylot_kod as trasa,
  count(case when czas_opoznienia >= 180 then 1 end) opoznione,
  count(1) wszystkie,
  count(case when czas_opoznienia >= 180 then 1 end)/count(1)::NUMERIC ile_razy_opoznione180 -- Lista najczęściej zakłóconych: opóźnionych 180min
from o_trasy
GROUP BY 1
    having count(1) > 500
ORDER BY 4 DESC;

select wylot_kod || '-' || przylot_kod as trasa,
  count(case when wylot_status = 'CX' then 1 end) opoznione,
  count(1) wszystkie,
  count(case when wylot_status = 'CX' then 1 end)/count(1)::NUMERIC ile_razy_anulowane -- Lista najczęściej zakłóconych: anulowane
from o_trasy
GROUP BY 1
      having count(1) > 500
ORDER BY 4 DESC



