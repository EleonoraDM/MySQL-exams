USE ruk_database;

CREATE TABLE `branches`
(
    `id`   INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE `employees`
(
    `id`         INT AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(20)    NOT NULL,
    `last_name`  VARCHAR(20)    NOT NULL,
    `salary`     DECIMAL(10, 2) NOT NULL,
    `started_on` DATE           NOT NULL,
    `branch_id`  INT            NOT NULL,
    CONSTRAINT `fk_employees_branches`
        FOREIGN KEY (`branch_id`)
            REFERENCES `branches` (`id`)
);

CREATE TABLE `clients`
(
    `id`        INT AUTO_INCREMENT PRIMARY KEY,
    `full_name` VARCHAR(50) NOT NULL,
    `age`       INT         NOT NULL
);

CREATE TABLE `employees_clients`
(
    `employee_id` INT,
    `client_id`   INT,
    CONSTRAINT `pk_employees_clients`
        PRIMARY KEY (`employee_id`, `client_id`),
    CONSTRAINT `fk_employees_clients`
        FOREIGN KEY (`employee_id`)
            REFERENCES employees (`id`),
    CONSTRAINT `fk_clients_employees`
        FOREIGN KEY (`client_id`)
            REFERENCES clients (id)
);

CREATE TABLE `bank_accounts`
(
    `id`             INT AUTO_INCREMENT PRIMARY KEY,
    `account_number` VARCHAR(10)    NOT NULL,
    `balance`        DECIMAL(10, 2) NOT NULL,
    `client_id`      INT            NOT NULL UNIQUE,
    CONSTRAINT `fk_bank_accounts_clients`
        FOREIGN KEY (`client_id`)
            REFERENCES clients (`id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `cards`
(
    `id`              INT AUTO_INCREMENT PRIMARY KEY,
    `card_number`     VARCHAR(19) NOT NULL,
    `card_status`     VARCHAR(7)  NOT NULL,
    `bank_account_id` INT         NOT NULL,
    CONSTRAINT `fk_cards_bank_accounts`
        FOREIGN KEY (bank_account_id)
            REFERENCES bank_accounts (id) ON DELETE CASCADE ON UPDATE CASCADE
);

