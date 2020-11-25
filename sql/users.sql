SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `users` DEFAULT CHARACTER SET utf8 ;
USE `users` ;

CREATE TABLE IF NOT EXISTS `registration_methods` (
  `id` INT NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Способ регистрации: форма социальные сети';

-- -----------------------------------------------------
-- Table `mydb`.`user_statuses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `user_statuses` (
  `id` INT NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Статус пользователя: 0 - новый, 1 - активирован, 2 - отключен\n';

-- -----------------------------------------------------
-- Table `mydb`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `public_name` VARCHAR(255) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления записи',
  `last_loggedin_at` DATETIME NULL COMMENT 'Последний раз входил',
  `registration_methods_id` INT NOT NULL,
  `user_statuses_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_users_registration_methods1_idx` (`registration_methods_id` ASC) VISIBLE,
  INDEX `fk_users_user_statuses1_idx` (`user_statuses_id` ASC) VISIBLE,
  CONSTRAINT `fk_users_registration_methods1`
    FOREIGN KEY (`registration_methods_id`)
    REFERENCES `registration_methods` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_user_statuses1`
    FOREIGN KEY (`user_statuses_id`)
    REFERENCES `user_statuses` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Пользователи';

-- -----------------------------------------------------
-- Table `social_networks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `social_networks` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Социальные сети для регистрации и логина';

-- -----------------------------------------------------
-- Table `user_social_networks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `user_social_networks` (
  `social_networks_id` INT NOT NULL,
  `users_id` INT NOT NULL,
  `login` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`social_networks_id`, `users_id`),
  INDEX `fk_user_social_networks_users1_idx` (`users_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_social_networks_social_networks1`
    FOREIGN KEY (`social_networks_id`)
    REFERENCES `social_networks` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_social_networks_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `subscription_plans`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `subscription_plans` (
  `id` INT NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `price` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Планы подписки';

-- -----------------------------------------------------
-- Table `subscriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `subscriptions` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `users_id` INT NOT NULL,
  `subscription_plans_id` INT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `price` DECIMAL(12,2) NOT NULL COMMENT 'Стоимость из subscription_plans',
  `title` VARCHAR(255) NOT NULL COMMENT 'Название плана из subscription_plans',
  `started_at` DATETIME NOT NULL COMMENT 'Дата начала подписки',
  `ended_at` DATETIME NOT NULL COMMENT 'Дата окончания подписки',
  PRIMARY KEY (`id`),
  INDEX `fk_subscriptions_users1_idx` (`users_id` ASC) VISIBLE,
  INDEX `fk_subscriptions_subscription_plans1_idx` (`subscription_plans_id` ASC) VISIBLE,
  CONSTRAINT `fk_subscriptions_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_subscriptions_subscription_plans1`
    FOREIGN KEY (`subscription_plans_id`)
    REFERENCES `subscription_plans` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Подписки';

-- -----------------------------------------------------
-- Table `balance_operation_statuses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `balance_operation_statuses` (
  `id` INT NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Статус балансовой операции: 1 - new, 2 - processing, 3 - completed';

-- -----------------------------------------------------
-- Table `balance_operation_types`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `balance_operation_types` (
  `id` INT NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Тип балансовой операции: 1 - депозит, 2 - вывод, 3 - положительная балансовая коррекция, 4 - отрицательная балансовая коррекция\n';

-- -----------------------------------------------------
-- Table `balance_operations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `balance_operations` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `amount` DECIMAL(10,2) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления записи',
  `balance_operation_statuses_id` INT NOT NULL,
  `balance_operation_types_id` INT NOT NULL,
  `payment_systems_id` INT NOT NULL,
  `users_id` INT NOT NULL,
  `wallet` VARCHAR(255) NULL COMMENT 'Кошелёк клиента, с которым проводилась операция',
  `completed_at` DATETIME NULL,
  `comission_amount` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_balance_operations_balance_operation_statuses1_idx` (`balance_operation_statuses_id` ASC) VISIBLE,
  INDEX `fk_balance_operations_balance_operation_types1_idx` (`balance_operation_types_id` ASC) VISIBLE,
  INDEX `fk_balance_operations_payment_systems1_idx` (`payment_systems_id` ASC) VISIBLE,
  INDEX `fk_balance_operations_users1_idx` (`users_id` ASC) VISIBLE,
  CONSTRAINT `fk_balance_operations_balance_operation_statuses1`
    FOREIGN KEY (`balance_operation_statuses_id`)
    REFERENCES `balance_operation_statuses` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_balance_operations_balance_operation_types1`
    FOREIGN KEY (`balance_operation_types_id`)
    REFERENCES `balance_operation_types` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_balance_operations_payment_systems1`
    FOREIGN KEY (`payment_systems_id`)
    REFERENCES `payment_systems` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_balance_operations_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Балансовые операции';

-- -----------------------------------------------------
-- Table `user_logs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `user_logs` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `users_id` INT NOT NULL,
  `data` JSON NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_user_logs_users1_idx` (`users_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_logs_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Логи пользователей';

-- -----------------------------------------------------
-- Table `balance_operation_logs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `balance_operation_logs` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `balance_operations_id` INT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `data` JSON NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_balance_operation_data_balance_operations1_idx` (`balance_operations_id` ASC) VISIBLE,
  CONSTRAINT `fk_balance_operation_data_balance_operations1`
    FOREIGN KEY (`balance_operations_id`)
    REFERENCES `balance_operations` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Лог балансовой операции';

-- -----------------------------------------------------
-- Table `avatar_sizes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `avatar_sizes` (
  `width` TINYINT NOT NULL,
  `height` TINYINT NOT NULL,
  `alias` VARCHAR(255) NOT NULL COMMENT 'Алиас для урла типа 200x200',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления записи',
  PRIMARY KEY (`width`, `height`),
  UNIQUE INDEX `alias_UNIQUE` (`alias` ASC) VISIBLE)
ENGINE = InnoDB
COMMENT = 'Размеры аватаров';

-- -----------------------------------------------------
-- Table `user_avatars`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `user_avatars` (
  `users_id` INT NOT NULL,
  `avatar_sizes_width` TINYINT NOT NULL,
  `avatar_sizes_height` TINYINT NOT NULL,
  `location` VARCHAR(255) NOT NULL,
  `server` VARCHAR(255) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления записи',
  PRIMARY KEY (`users_id`, `avatar_sizes_width`, `avatar_sizes_height`),
  INDEX `fk_user_avatars_avatar_sizes1_idx` (`avatar_sizes_width` ASC, `avatar_sizes_height` ASC) VISIBLE,
  CONSTRAINT `fk_user_avatars_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_avatars_avatar_sizes1`
    FOREIGN KEY (`avatar_sizes_width` , `avatar_sizes_height`)
    REFERENCES `avatar_sizes` (`width` , `height`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `active_subscriptions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `active_subscriptions` (
  `subscription_plans_id` INT NOT NULL,
  `users_id` INT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления записи',
  `started_at` DATETIME NOT NULL COMMENT 'Дата начала подписки',
  `ended_at` DATETIME NOT NULL COMMENT 'Дата окончания подписки',
  PRIMARY KEY (`subscription_plans_id`, `users_id`),
  INDEX `fk_acitve_subscriptions_users1_idx` (`users_id` ASC) VISIBLE,
  CONSTRAINT `fk_acitve_subscriptions_subscription_plans1`
    FOREIGN KEY (`subscription_plans_id`)
    REFERENCES `subscription_plans` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_acitve_subscriptions_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `subscription_plan_features`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `subscription_plan_features` (
  `id` INT NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `subscription_plans_id` INT NOT NULL,
  PRIMARY KEY (`id`, `subscription_plans_id`),
  INDEX `fk_subscription_plan_features_subscription_plans1_idx` (`subscription_plans_id` ASC) VISIBLE,
  CONSTRAINT `fk_subscription_plan_features_subscription_plans1`
    FOREIGN KEY (`subscription_plans_id`)
    REFERENCES `subscription_plans` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Доступные возможности в плане';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
