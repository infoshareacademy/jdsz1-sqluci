/*3) lista graczy którzy przeszli wszystkie levele (mieli sesje na kazym levelu)*/
SELECT sesje_gry.graczid, gracze.login, COUNT(DISTINCT sesje_gry.levelid)
FROM sesje_gry
INNER JOIN gracze ON sesje_gry.graczid = gracze.id
GROUP BY sesje_gry.graczid, gracze.login
HAVING COUNT(DISTINCT sesje_gry.levelid) = 11;

