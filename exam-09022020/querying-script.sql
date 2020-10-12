/*# 5.	Players
# Extract from the Football Scout Database (fsd) database, info about all of the players.
# Order the results by players - salary descending.
# Required Columns
# •	first_name
# •	age
# •	salary*/

SELECT first_name, age, salary
FROM players
ORDER BY salary DESC;

/*# 6.	Young offense players without contract
# One of the coaches wants to know more about all the young players (under age of 23)
# who can strengthen his team in the offensive (played on position ‘A’).
# As he is not paying a transfer amount, he is looking only for those
# who have not signed a contract so far (haven’t hire_date)
# and have strength of more than 50.
# Order the results ascending by salary,
# then by age.
#
# Required Columns
# •	id (player)
# •	full_name
# •	age
# •	position
# •	hire_date*/

SELECT p.id,
       concat_ws(' ', p.first_name, p.last_name) AS `full_name`,
       p.age,
       p.position,
       p.hire_date
FROM players AS `p`
         JOIN skills_data AS `s` ON p.skills_data_id = s.id
WHERE p.age < 23
  AND p.position = 'A'
  AND p.hire_date IS NULL
  AND s.strength > 50
ORDER BY p.salary, p.age;


/*# 7.	Detail info for all teams
# Extract from the database all of the teams and the count of the players that they have.

# Order the results
#   descending by count of players,
#   then by fan_base descending.

# Required Columns
# •	team_name
# •	established
# •	fan_base
# •	count_of_players*/

SELECT t.name                                                              AS `team_name`,
       t.established,
       t.fan_base,
       (SELECT count(*) FROM players AS `p1` WHERE p1.team_id = p.team_id) AS `players_count`
FROM teams AS `t`
         LEFT JOIN players p ON t.id = p.team_id
GROUP BY t.name, t.fan_base
ORDER BY players_count DESC, t.fan_base DESC;

/*# 8.	The fastest player by towns

# Extract from the database, the fastest player (having max speed),
# in terms of towns where their team played.

# Order players by speed descending, then by town name.

# Skip players that played in team ‘Devify’
#
# Required Columns
# •	max_speed
# •	town_name*/

SELECT max(sd.speed) AS `max_speed`, (t2.name) AS `town_name`
FROM skills_data AS `sd`
         JOIN players p ON sd.id = p.skills_data_id
         RIGHT JOIN teams t ON p.team_id = t.id
         JOIN stadiums s ON t.stadium_id = s.id
         RIGHT JOIN towns t2 ON s.town_id = t2.id
WHERE t.name != 'Devify'
GROUP BY t2.name
ORDER BY max_speed DESC, t2.name;

/*# 9.	Total salaries and players by country
#
# And like everything else in this world, everything is ultimately about finances.
# Now you need to extract detailed information on the amount of all salaries
# given to football players by the criteria of the country in which they played.
#
# If there are no players in a country, display NULL.
#
# Order the results by total count of players in descending order,
# then by country name alphabetically.
#
# Required Columns
# •	name (country)
# •	total_sum_of_salaries
# •	total_count_of_players*/

SELECT c.name,
       count(p.id) AS `total_count_of_players`,
       sum(p.salary) AS `total_sum_of_salaries`
FROM players AS `p`
RIGHT JOIN teams t ON p.team_id = t.id
RIGHT JOIN stadiums s ON t.stadium_id = s.id
RIGHT JOIN towns t2 ON s.town_id = t2.id
RIGHT JOIN countries c ON t2.country_id = c.id
GROUP BY c.name
ORDER BY total_count_of_players DESC , c.name;

