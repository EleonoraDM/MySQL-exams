/*16. Modify spaceship
Create a user defined stored procedure with the name
  udp_modify_spaceship_light_speed_rate(spaceship_name VARCHAR(50), light_speed_rate_increse INT(11))
  that receives a spaceship name and light speed increase value
  and increases spaceship light speed ONLY IF THE GIVEN SPACESHIP EXISTS.
  If the modifying is not successful rollback any changes
  and throw an exception with error code ‘45000’
  and message: “Spaceship you are trying to modify does not exists.”
*/

CREATE PROCEDURE `udp_modify_spaceship_light_speed_rate`(IN spaceship_name VARCHAR(50), IN light_speed_rate_increase INT(11))
BEGIN
    START TRANSACTION;
    IF ((SELECT name FROM spaceships WHERE name = spaceship_name)) IS NULL
    THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Spaceship you are trying to modify does not exists.';
    ELSE
        UPDATE spaceships AS `sp`
        SET sp.light_speed_rate = sp.light_speed_rate + light_speed_rate_increase
        WHERE sp.name = spaceship_name;
    END IF;
END;

CALL udp_modify_spaceship_light_speed_rate('Fade', 1914);


SELECT name, light_speed_rate
FROM spaceships
WHERE name = 'Fade';
