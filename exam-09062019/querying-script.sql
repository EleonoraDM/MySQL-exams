/*
In case if there is a recommendation of data consistency and all of the tables
should be truncated before querying!
*/

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE bank_accounts;
TRUNCATE TABLE branches;
TRUNCATE TABLE cards;
TRUNCATE TABLE clients;
TRUNCATE TABLE employees;
TRUNCATE TABLE employees_clients;

SET FOREIGN_KEY_CHECKS = 1;

SELECT id, full_name
FROM clients
ORDER BY id;

/*06.	Newbies
One of your bosses has requested a functionality which checks the newly employed – highly paid people.
Extract from the database,
  all of the employees, which have salary greater than or equal to 100000
  and have started later than or equal to the 1st of January - 2018.

The salary should have a "$" as a prefix.

Order the results descending by salary, then by id.

Required Columns
•	id (employees)
•	full_name (first_name + " " + last_name)
•	salary
•	started_on
*/

SELECT id,
       concat(first_name, ' ', last_name) AS `full_name`,
       concat('$', salary),
       started_on
FROM employees
WHERE salary >= 100000
  AND started_on >= '2018-01-01'
ORDER BY salary DESC, id;

/*07.	Cards against Humanity
Extract from the database, all of the cards, and the clients that own them,
so that they end up in the following format:

  {card_number} : {full_name}

Order the results descending by card id.

Required Columns
•	id (cards)
•	card_token
*/

SELECT cr.id, (concat(cr.card_number, ' : ', cl.full_name)) AS `card_token`
FROM cards AS `cr`
         JOIN bank_accounts AS `ba` ON cr.bank_account_id = ba.id
         JOIN clients AS `cl` ON ba.client_id = cl.id
ORDER BY cr.id DESC;


/*08.	Top 5 Employees
Extract from the database, the top 5 employees, in terms of clients assigned to them.
Order the results descending by count of clients, and ascending by employee id.
Required Columns
•	name (employees)
•	started_on
•	count_of_clients
*/

SELECT concat_ws(' ', e.first_name, e.last_name) AS `name`,
       e.started_on,
       (SELECT count(ec.client_id)
        FROM employees_clients AS `ec`
        WHERE ec.employee_id = e.id
       )                                         AS `count_of_clients`
FROM employees AS `e`
ORDER BY count_of_clients DESC, e.id ASC;


/*09.	Branch cards
Extract from the database, all branches with the count of their issued cards.
Order the results by the count of cards DESC, then by branch name.

Required Columns
•	name (branch)
•	count_of_cards
*/

SELECT b.name AS `name`, (count(c2.id)) AS `count_of_cards`
FROM branches AS `b`
         JOIN employees AS `e` ON b.id = e.branch_id
         JOIN employees_clients ec ON e.id = ec.employee_id
         JOIN clients c ON ec.client_id = c.id
         JOIN bank_accounts ba ON c.id = ba.client_id
         JOIN cards c2 ON ba.id = c2.bank_account_id
GROUP BY b.name
ORDER BY count_of_cards DESC, b.name;


