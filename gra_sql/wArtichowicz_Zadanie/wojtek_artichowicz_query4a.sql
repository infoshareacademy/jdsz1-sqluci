/*4a) w jakich dniach gracze najczęściej wchodza do gry?*/
SELECT to_char(datawejscia, 'day') as weekDay, COUNT(to_char(datawejscia, 'day'))
FROM sesje_gry
GROUP BY weekDay
ORDER BY COUNT(to_char(datawejscia, 'day')) DESC;
