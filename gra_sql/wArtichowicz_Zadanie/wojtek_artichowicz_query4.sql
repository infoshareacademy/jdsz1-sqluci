/*4 w jakich dniach i godzinach gracze najczęściej wchodza do gry?*/
SELECT to_char(datawejscia, 'day') as weekDay, COUNT(to_char(datawejscia, 'day')), date_part('hour', datawejscia) as dayhour, COUNT( date_part('hour', datawejscia))
FROM sesje_gry
GROUP BY weekDay, dayhour
ORDER BY weekDay, COUNT(to_char(datawejscia, 'day')) DESC;