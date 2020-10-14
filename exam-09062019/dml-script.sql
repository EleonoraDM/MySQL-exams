/*02.	Insert
You will have to insert records of data into the CARDS table, based on the CLIENTS table.
For clients with id between 191 and 200 (inclusive),
insert data in the cards table with the following values:
•	card_number – set it to full name of the client, but reversed!
•	card_status – set it to "Active".
•	bank_account_id –set it to client's id value.
*/

INSERT INTO cards(card_number, card_status, bank_account_id)
SELECT reverse(c.full_name), 'Active', c.id
FROM clients AS `c`
WHERE c.id BETWEEN 191 AND 200;

/*03.	Update
Update all clients which have THE SAME ID AS THE EMPLOYEE THEY ARE APPOINTED TO.
Set their employee_id with the employee with THE LOWEST COUNT OF CLIENTS.
If there are 2 such employees with equal count of clients, take the one with the lowest id.
*/


UPDATE employees_clients AS `ec`
SET ec.employee_id = (SELECT ec1.employee_id
                      FROM (SELECT * FROM employees_clients) AS `ec1`
                      GROUP BY ec1.employee_id
                      ORDER BY count(ec1.client_id), ec1.employee_id
                      LIMIT 1)
WHERE ec.client_id = ec.employee_id;

/*04.	Delete
R.U.K. Bank is a sophisticated network.
As such, it cannot allow procrastination and lazy behavior.
Delete all employees which do not have any clients.
*/

DELETE
FROM employees
WHERE id = (SELECT e1.id
            FROM (SELECT * FROM employees) AS `e1`
                     LEFT JOIN employees_clients ec ON e1.id = ec.employee_id
            WHERE ec.client_id IS NULL);



