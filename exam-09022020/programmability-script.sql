/*10.	Find all players that play on stadium
Create a user defined function with the name
  udf_stadium_players_count (stadium_name VARCHAR(30))
  that receives a stadium’s name and returns the number of players that play home matches there.
*/

CREATE FUNCTION `udf_stadium_players_count`(`stadium_name` VARCHAR(30))
    RETURNS INT DETERMINISTIC
BEGIN
    DECLARE `players_count` INT;
    SET players_count := (SELECT COUNT(p.id) AS `players_count`
                          FROM players AS `p`
                                   JOIN teams t ON p.team_id = t.id
                                   JOIN stadiums s ON t.stadium_id = s.id
                          WHERE s.name = stadium_name);
    RETURN players_count;
END;

SELECT udf_stadium_players_count('Jaxworks') AS `count`;

/*11.	Find good playmaker by teams
Create a stored procedure udp_find_playmaker which accepts the following parameters:
•	min_dribble_points
•	team_name (with max length 45)
And extracts data about the players with the given skill stats
- (more than min_dribble_points),
- played for given team (team_name)
- and have more than average speed for all players.
Order players by speed descending.
Select only the best one.

Show all needed info for this player: full_name, age, salary, dribbling, speed, team name.
CALL udp_find_playmaker (20, ‘Skyble’);*/


CREATE PROCEDURE `udp_find_playmaker`(IN `min_dribble_points` INT, IN `team_name` VARCHAR(45))
BEGIN
    SELECT concat_ws(' ', p.first_name, p.last_name) AS `full_name`,
           p.age,
           p.salary,
           sd.dribbling,
           sd.speed,
           t.name                                    AS `team_name`
    FROM players AS `p`
             JOIN skills_data sd ON p.skills_data_id = sd.id
             JOIN teams t ON p.team_id = t.id
    WHERE sd.dribbling > min_dribble_points
      AND t.name = team_name
      AND sd.speed > (SELECT avg(sd1.speed) FROM skills_data AS `sd1`)
    ORDER BY sd.speed DESC
    LIMIT 1;
END;

CALL udp_find_playmaker (20, 'Skyble');