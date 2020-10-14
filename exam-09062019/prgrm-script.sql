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


/*11.	Extract Client Info
Create a stored procedure udp_clientinfo which accepts the following parameters:
•	full_name
And extracts data about the client with the given full name.
Aside from the full_name, the procedure should extract
  the client's age,
  bank account number
  and balance.
The account’s salary should have "$" prefix.

Result
full_name	age	account_number	balance
Hunter Wesgate	33	69666616-8	$803355.32
*/

CREATE PROCEDURE `udp_clientinfo`(IN full_name VARCHAR(50))
BEGIN
    SELECT c.full_name,
           c.age,
           ba.account_number,
           concat('$', ba.balance) AS `balance`
    FROM clients c
             LEFT JOIN bank_accounts ba ON c.id = ba.client_id
    WHERE c.full_name = full_name;
END;

CALL udp_clientinfo('Hunter Wesgate');