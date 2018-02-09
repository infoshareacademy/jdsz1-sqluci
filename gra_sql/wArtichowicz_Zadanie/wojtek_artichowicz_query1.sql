/*1) lista graczy z liczbą sesji, oraz średnim czasem sesji, oraz liczbą zdobytych punktow*/
SELECT sesje_gry.graczid, gracze.login,  COUNT(*) as Liczba_sesji, 
       AVG(sesje_gry.datawyjscia-sesje_gry.datawejscia) as Sredni_czas_gry, 
       SUM(sesje_gry.liczbapunktow) as calk_liczba_punktow
FROM sesje_gry
INNER JOIN gracze ON sesje_gry.graczid = gracze.id
GROUP BY sesje_gry.graczid, gracze.login
ORDER BY sesje_gry.graczid;