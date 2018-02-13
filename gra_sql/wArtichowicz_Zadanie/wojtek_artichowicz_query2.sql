/* 2) lista graczy bez żadnej sesji*/
SELECT gracze.login 
FROM gracze 
LEFT OUTER JOIN sesje_gry ON gracze.id= sesje_gry.graczid
WHERE sesje_gry IS NULL;
