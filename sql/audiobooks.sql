SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `audiobooks` DEFAULT CHARACTER SET utf8 ;
USE `audiobooks` ;

-- -----------------------------------------------------
-- Table `mydb`.`publishers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `publishers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(512) NOT NULL COMMENT 'Название компании',
  `description` TEXT NOT NULL COMMENT 'Описание',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления записи',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Правообладатель';

CREATE TABLE IF NOT EXISTS `book_statuses` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Статус книги\n';

-- -----------------------------------------------------
-- Table `books`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `books` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(512) NOT NULL COMMENT 'Название книги',
  `isbn` VARCHAR(13) NOT NULL COMMENT 'ISBN',
  `annotation` TEXT NOT NULL COMMENT 'Аннотация',
  `published_year` TINYINT NOT NULL COMMENT 'Год опубликования',
  `age_limitation` VARCHAR(3) NOT NULL COMMENT 'Ограничение по возрасту',
  `book_volume` JSON NOT NULL COMMENT 'Объем книги вида {pages: 300, images: 255}',
  `publishers_id` INT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления записи',
  `book_statuses_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `isbn_idx` (`isbn` ASC) VISIBLE,
  INDEX `fk_books_publisher_idx` (`publishers_id` ASC) VISIBLE,
  INDEX `fk_books_book_statuses1_idx` (`book_statuses_id` ASC) VISIBLE,
  CONSTRAINT `fk_books_publisher`
    FOREIGN KEY (`publishers_id`)
    REFERENCES `publishers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_books_book_statuses1`
    FOREIGN KEY (`book_statuses_id`)
    REFERENCES `book_statuses` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Книги';


-- -----------------------------------------------------
-- Table `genres`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `genres` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NULL COMMENT 'Название жанра',
  `parent_id` INT NULL COMMENT 'ID родителя',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления записи',
  PRIMARY KEY (`id`),
  INDEX `fk_genres_genres1_idx` (`parent_id` ASC) VISIBLE,
  CONSTRAINT `fk_genres_genres1`
    FOREIGN KEY (`parent_id`)
    REFERENCES `genres` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Жанры древовидная структура';

-- -----------------------------------------------------
-- Table `book_genres`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `book_genres` (
  `genres_id` INT NOT NULL,
  `books_id` INT NOT NULL,
  PRIMARY KEY (`genres_id`, `books_id`),
  INDEX `fk_book_genres_books1_idx` (`books_id` ASC) VISIBLE,
  CONSTRAINT `fk_book_genres_genres1`
    FOREIGN KEY (`genres_id`)
    REFERENCES `genres` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_book_genres_books1`
    FOREIGN KEY (`books_id`)
    REFERENCES `books` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tags`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tags` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL COMMENT 'Тэг',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления записи',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Тэги';

-- -----------------------------------------------------
-- Table `book_tags`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `book_tags` (
  `books_id` INT NOT NULL,
  `tags_id` INT NOT NULL,
  PRIMARY KEY (`books_id`, `tags_id`),
  INDEX `fk_book_tags_tags1_idx` (`tags_id` ASC) VISIBLE,
  CONSTRAINT `fk_book_tags_books1`
    FOREIGN KEY (`books_id`)
    REFERENCES `books` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_book_tags_tags1`
    FOREIGN KEY (`tags_id`)
    REFERENCES `tags` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `authors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `authors` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(255) NULL COMMENT 'Имя',
  `middle_name` VARCHAR(255) NULL COMMENT 'Отчество',
  `last_name` VARCHAR(255) NOT NULL COMMENT 'Фамилия',
  `description` TEXT NULL COMMENT 'Биография',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления записи',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Автор';

-- -----------------------------------------------------
-- Table `book_authors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `book_authors` (
  `authors_id` INT NOT NULL,
  `books_id` INT NOT NULL,
  `book_author_order` INT NOT NULL DEFAULT 1 COMMENT 'Порядок',
  PRIMARY KEY (`authors_id`, `books_id`),
  INDEX `fk_book_authors_books1_idx` (`books_id` ASC) VISIBLE,
  CONSTRAINT `fk_book_authors_authors1`
    FOREIGN KEY (`authors_id`)
    REFERENCES `authors` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_book_authors_books1`
    FOREIGN KEY (`books_id`)
    REFERENCES `books` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `book_file_types`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `book_file_types` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `book_files`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `book_files` (
  `book_file_types_id` INT NOT NULL,
  `books_id` INT NOT NULL,
  `file_number` INT NOT NULL DEFAULT 0,
  `location` VARCHAR(255) NOT NULL COMMENT 'Нахождение',
  `server` VARCHAR(255) NOT NULL COMMENT 'Сервер',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления записи',
  PRIMARY KEY (`book_file_types_id`, `books_id`, `file_number`),
  INDEX `fk_book_files_books1_idx` (`books_id` ASC) VISIBLE,
  CONSTRAINT `fk_book_files_book_file_types1`
    FOREIGN KEY (`book_file_types_id`)
    REFERENCES `book_file_types` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_book_files_books1`
    FOREIGN KEY (`books_id`)
    REFERENCES `books` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Файлы книги';

-- -----------------------------------------------------
-- Table `payment_systems`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `payment_systems` (
  `id` INT NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `alias` VARCHAR(255) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления записи',
  `min_deposit_amount` DECIMAL(12,2) NOT NULL,
  `max_deposit_amount` DECIMAL(12,2) NOT NULL,
  `comission_percent` DECIMAL(4,2) NOT NULL DEFAULT 0.0,
  `comission_fix_amount` DECIMAL(4,2) NOT NULL DEFAULT 0.0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `alias_UNIQUE` (`alias` ASC) VISIBLE)
ENGINE = InnoDB
COMMENT = 'Платёжные системы';

-- -----------------------------------------------------
-- Table `series`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `series` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(512) NOT NULL COMMENT 'Название серии книг',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления записи',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Серия книг';

-- -----------------------------------------------------
-- Table `book_series`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `book_series` (
  `series_id` INT NOT NULL,
  `books_id` INT NOT NULL,
  `series_order` TINYINT NOT NULL COMMENT 'Порядковый номер в серии',
  PRIMARY KEY (`series_id`, `books_id`),
  INDEX `fk_book_series_books1_idx` (`books_id` ASC) VISIBLE,
  UNIQUE INDEX `series_id_series_order` (`series_id` ASC, `series_order` ASC) VISIBLE,
  CONSTRAINT `fk_book_series_series1`
    FOREIGN KEY (`series_id`)
    REFERENCES `series` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_book_series_books1`
    FOREIGN KEY (`books_id`)
    REFERENCES `books` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Серия книги';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
