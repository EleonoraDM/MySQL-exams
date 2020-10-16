create DATABASE `colonial_journey_db`;
USE colonial_journey_db;


create TABLE IF NOT EXISTS `planets`
(
    `id`   INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(30) NOT NULL
);

create TABLE IF NOT EXISTS `spaceships`
(
    `id`               INT AUTO_INCREMENT PRIMARY KEY,
    `name`             VARCHAR(50) NOT NULL,
    `manufacturer`     VARCHAR(30) NOT NULL,
    `light_speed_rate` INT DEFAULT 0
);

create TABLE IF NOT EXISTS `colonists`
(
    `id`         INT AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(20) NOT NULL,
    `last_name`  VARCHAR(20) NOT NULL,
    `ucn`        CHAR(10)    NOT NULL UNIQUE,
    `birth_date` DATE        NOT NULL
);

create TABLE IF NOT EXISTS `spaceports`
(
    `id`        INT AUTO_INCREMENT PRIMARY KEY,
    `name`      VARCHAR(50) NOT NULL,
    `planet_id` INT         NOT NULL,
    CONSTRAINT `fk_spaceports_planets`
        FOREIGN KEY (`planet_id`)
            REFERENCES `planets` (`id`) ON delete CASCADE ON update CASCADE
);

CREATE TABLE IF NOT EXISTS `journeys`
(
    `id`                       INT AUTO_INCREMENT PRIMARY KEY,
    `journey_start`            DATETIME                                                      NOT NULL,
    `journey_end`              DATETIME                                                      NOT NULL,
    `purpose`                  ENUM ( 'Medical' , 'Technical' , 'Educational' , 'Military' ) NOT NULL,
    `destination_spaceport_id` INT,
    `spaceship_id`             INT,
    CONSTRAINT `fk_journeys_spaceports`
        FOREIGN KEY (`destination_spaceport_id`)
            REFERENCES spaceports (id),
    CONSTRAINT `fk_journeys_spaceships`
        FOREIGN KEY (`spaceship_id`)
            REFERENCES spaceships (id)
);

CREATE TABLE `travel_cards`
(
    `id`                 INT AUTO_INCREMENT PRIMARY KEY,
    `card_number`        CHAR(10) NOT NULL UNIQUE,
    `job_during_journey` ENUM ('Pilot', 'Engineer', 'Trooper', 'Cleaner', 'Cook') NOT NULL,
    `colonist_id`        INT      NOT NULL,
    `journey_id`         INT,
    CONSTRAINT `fk_travel_cards_colonists`
        FOREIGN KEY (colonist_id)
            REFERENCES colonists (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_travel_cards_journeys`
        FOREIGN KEY (journey_id)
            REFERENCES journeys (id)
);
