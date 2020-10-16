/*04.Extract all travel cards
Extract from the database, all travel cards.
Sort the results by card number ascending.
Required Columns
•	card_number
•	job_during_journey*/

SELECT card_number, job_during_journey
FROM travel_cards
ORDER BY card_number;

/*05. Extract all colonists
Extract from the database, all colonists.
Sort the results by first name, them by last name, and finally by id in ascending order.

Required Columns
•	id
•	full_name(first_name + last_name separated by a single space)
•	ucn*/

SELECT id, concat_ws(' ', first_name, last_name) AS `full_name`, ucn
FROM colonists
ORDER BY first_name, last_name, id;

/*06.	Extract all military journeys
Extract from the database, all Military journeys.
Sort the results ascending by journey start.

Required Columns
•	id
•	journey_start
•	journey_end*/

SELECT id, journey_start, journey_end
FROM journeys
WHERE purpose = 'Military';

/*07.	Extract all pilots
Extract from the database all colonists, which have a pilot job.
Sort the result by id, ascending.

Required Columns
•	id
•	full_name*/

SELECT c.id, concat_ws(' ', c.first_name, c.last_name) AS `full_name`
FROM colonists AS `c`
         JOIN travel_cards tc ON c.id = tc.colonist_id
WHERE job_during_journey = 'Pilot'
ORDER BY c.id;

/*08.	Count all colonists that are on technical journey
Count all colonists, that are on technical journey.

Required Columns
•	Count*/

SELECT count(tc.colonist_id) AS `count`
FROM journeys AS `j`
         JOIN travel_cards AS `tc` ON j.id = tc.journey_id
WHERE j.purpose = 'Technical';

/*09.Extract the fastest spaceship
Extract from the database the fastest spaceship
and its destination spaceport name.
In other words, the ship with the highest light speed rate.

Required Columns
•	spaceship_name
•	spaceport_name*/

SELECT ss.name, sp.name
FROM spaceships AS `ss`
         JOIN journeys AS `j` ON ss.id = j.spaceship_id
         JOIN spaceports AS `sp` ON j.destination_spaceport_id = sp.id
WHERE (SELECT max(ss1.light_speed_rate)
       FROM spaceships AS `ss1`
       WHERE ss1.id = ss.id)
ORDER BY ss.light_speed_rate DESC
LIMIT 1;

/*10.Extract spaceships with pilots younger than 30 years
Extract from the database those spaceships, which have pilots, younger than 30 years old.
In other words, 30 years from 01/01/2019.
Sort the results alphabetically by spaceship name.

Required Columns
•	name
•	manufacturer*/

SELECT ss.name, ss.manufacturer
FROM spaceships AS `ss`
         JOIN journeys AS `j` ON ss.id = j.spaceship_id
         JOIN travel_cards AS `tc` ON j.id = tc.journey_id
         JOIN colonists AS `c` ON tc.colonist_id = c.id
WHERE tc.job_during_journey = 'Pilot'
  AND timestampdiff(YEAR, c.birth_date, '2019-01-01') < 30
ORDER BY ss.name;


/*11. Extract all educational mission planets and spaceports
Extract from the database names of all planets and their spaceports,
which have educational missions.
Sort the results by spaceport name in descending order.

Required Columns
•	planet_name
•	spaceport_name*/

SELECT p.name AS `planet_name`, sp.name AS `spaceport_name`
FROM planets AS `p`
         JOIN spaceports AS `sp` ON p.id = sp.planet_id
         JOIN journeys AS `j` ON sp.id = j.destination_spaceport_id
WHERE j.purpose = 'Educational'
ORDER BY spaceport_name DESC;


/*12. Extract all planets and their journey count
Extract from the database all planets’ names and their journeys count.
Order the results by journeys count, descending and by planet name ascending.
Required Columns
•	planet_name
•	journeys_count*/

SELECT p.name AS `planet_name`, count(j.id) AS `journeys_count`
FROM planets AS `p`
         LEFT JOIN spaceports AS `sp` ON p.id = sp.planet_id
         LEFT JOIN journeys AS `j` ON sp.id = j.destination_spaceport_id
GROUP BY planet_name
ORDER BY journeys_count DESC, planet_name;


/*13.Extract the SHORTEST journey
Extract from the database the shortest journey,
its destination spaceport name,
planet name
and purpose.
Required Columns
•	Id
•	planet_name
•	spaceport_name
•	journey_purpose*/

SELECT j.id,
       TIMESTAMPDIFF(YEAR, j.journey_start, j.journey_end) AS `duration`,
       p.name                                              AS `planet_name`,
       s.name                                              AS `spaceport_name`,
       j.purpose                                           AS `journey_purpose`
FROM journeys AS `j`
         JOIN spaceports s ON j.destination_spaceport_id = s.id
         JOIN planets p ON s.planet_id = p.id
WHERE (SELECT TIMESTAMPDIFF(YEAR, j1.journey_start, j1.journey_end)
       FROM journeys AS `j1`
       WHERE j1.id = j.id)
ORDER BY duration
LIMIT 1;


SELECT p.name AS `planet_name`, count(j.id) AS `journeys_count`
FROM planets AS `p`
         LEFT JOIN spaceports AS `sp` ON p.id = sp.planet_id
         LEFT JOIN journeys AS `j` ON sp.id = j.destination_spaceport_id
GROUP BY planet_name
ORDER BY journeys_count DESC, planet_name;


/*14.Extract the less popular job
Extract from the database the LESS POPULAR JOB in the LONGEST JOURNEY.
In other words, THE JOB WITH LESS ASSIGN COLONISTS.

Required Columns
•	job_name*/

SELECT tc.job_during_journey AS `job_name`
FROM travel_cards AS `tc`
         JOIN journeys AS `j` ON tc.journey_id = j.id
WHERE (SELECT max(timestampdiff(YEAR, j1.journey_start, j1.journey_end))
       FROM journeys AS `j1`
       WHERE j1.id = j.id)
  AND (SELECT count(tc1.colonist_id) AS `count`
       FROM travel_cards AS `tc1`
       WHERE tc1.job_during_journey = tc.job_during_journey
       ORDER BY count
       LIMIT 1)
LIMIT 1;