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

create procedure `udp_clientinfo`(IN full_name VARCHAR(50))
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
