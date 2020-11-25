SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `private` DEFAULT CHARACTER SET utf8 ;
USE `private` ;

-- -----------------------------------------------------
-- Table `user_identity_data`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `user_identity_data` (
  `users_id` INT NOT NULL,
  `login` VARCHAR(255) NOT NULL,
  `password_hash` VARCHAR(64) NOT NULL,
  `password_salt` VARCHAR(64) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления записи',
  PRIMARY KEY (`users_id`),
  UNIQUE INDEX `login_UNIQUE` (`login` ASC) VISIBLE,
  CONSTRAINT `fk_user_identity_data_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `users.users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `payment_system_data`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `payment_system_data` (
  `payment_systems_id` INT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления записи',
  `data` JSON NOT NULL,
  PRIMARY KEY (`payment_systems_id`),
  CONSTRAINT `fk_payment_system_data_payment_systems1`
    FOREIGN KEY (`payment_systems_id`)
    REFERENCES `users.payment_systems` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `social_network_data`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `social_network_data` (
  `social_networks_id` INT NOT NULL,
  `client_id` VARCHAR(255) NOT NULL,
  `client_secret` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`social_networks_id`),
  CONSTRAINT `fk_social_network_data_social_networks1`
    FOREIGN KEY (`social_networks_id`)
    REFERENCES `users.social_networks` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `password_recovery_codes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `password_recovery_codes` (
  `users_id` INT NOT NULL,
  `code` VARCHAR(8) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `expired_at` DATETIME NOT NULL,
  UNIQUE INDEX `code_UNIQUE` (`code` ASC) VISIBLE,
  PRIMARY KEY (`users_id`),
  CONSTRAINT `fk_password_recovery_codes_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Коды для восстановления пароля';