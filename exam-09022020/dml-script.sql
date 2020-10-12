USE fsd;

INSERT INTO coaches(first_name, last_name, salary, coach_level)
SELECT first_name, last_name, salary, char_length(first_name)
FROM players
WHERE age > 44;

UPDATE coaches AS `c`
    JOIN players_coaches pc ON c.id = pc.coach_id
SET coach_level = coach_level + 1
WHERE pc.player_id IS NOT NULL
  AND first_name LIKE ('A%');

DELETE
FROM players
WHERE age > 44;