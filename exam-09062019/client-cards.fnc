/*
10.	Extract client cards count
Create a user defined function with the name udf_client_cards_count(name VARCHAR(30))
that receives a client's full name and returns the number of cards he has.
Required Columns
•	full_name (clients)
•	cards (count of cards)
*/

CREATE FUNCTION `udf_clients_cards_count`(name VARCHAR(30))
    RETURNS INT DETERMINISTIC
BEGIN
    DECLARE cards INT;
    SET cards := (SELECT count(cr.id)
                  FROM cards AS `cr`
                           RIGHT JOIN bank_accounts ba ON cr.bank_account_id = ba.id
                           RIGHT JOIN clients c ON ba.client_id = c.id
                  WHERE c.full_name = name);
    RETURN cards;
END;

SELECT c.full_name, (SELECT udf_clients_cards_count('Baxy David')) AS `cards`
FROM clients AS `c`
WHERE c.full_name = 'Baxy David';