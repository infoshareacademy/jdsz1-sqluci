/*4b) w jakich godzinach gracze najczęściej wchodza do gry?*/
SELECT date_part('hour', datawejscia) as dayhour, COUNT( date_part('hour', datawejscia))
FROM sesje_gry
GROUP BY date_part('hour', datawejscia)
ORDER BY COUNT(date_part('hour', datawejscia)) DESC;
