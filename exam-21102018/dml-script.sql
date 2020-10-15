USE colonial_journey_db;

/*01.	Data Insertion
You will have to INSERT records of data into the travel_cards table,
based on the colonists table.
For colonists with id between 96 and 100(inclusive),

insert data in the travel_cards table with the following values:

•	For colonists born after ‘1980-01-01’, the CARD_NUMBER must be combination
    between the year of birth, day and the first 4 digits from the ucn.
    For the rest – year of birth, month and the last 4 digits from the ucn.
•	For colonists with id that can be divided by 2 without remainder, JOB must be ‘Pilot’,
    for colonists with id that can be divided by 3 without remainder – ‘Cook’,
    and everyone else – ‘Engineer’.
•	JOURNEY ID is the first digit from the colonist’s ucn.*/

INSERT INTO travel_cards(card_number, job_during_journey, colonist_id, journey_id)
SELECT if(c.birth_date > '1980-01-01',
          concat(year(c.birth_date), day(c.birth_date), left(c.ucn, 4)),
          concat(year(c.birth_date), month(c.birth_date), right(c.ucn, 4))),
       CASE
           WHEN c.id % 2 = 0 THEN 'Pilot'
           WHEN c.id % 3 = 0 THEN 'Cook'
           ELSE 'Engineer' END,
       c.id,
       left(c.ucn, 1)
FROM colonists AS `c`
WHERE c.id BETWEEN 96 AND 100;


