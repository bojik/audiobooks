-- MySQL dump 10.13  Distrib 8.0.22, for Linux (x86_64)
--
-- Host: localhost    Database: private
-- ------------------------------------------------------
-- Server version	8.0.22

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `password_recovery_codes`
--

DROP TABLE IF EXISTS `password_recovery_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_recovery_codes` (
  `users_id` int NOT NULL,
  `code` varchar(8) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '  ',
  `expired_at` datetime NOT NULL,
  PRIMARY KEY (`users_id`),
  UNIQUE KEY `code_UNIQUE` (`code`),
  CONSTRAINT `fk_password_recovery_codes_users1` FOREIGN KEY (`users_id`) REFERENCES `users`.`users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='   ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_recovery_codes`
--

LOCK TABLES `password_recovery_codes` WRITE;
/*!40000 ALTER TABLE `password_recovery_codes` DISABLE KEYS */;
INSERT INTO `password_recovery_codes` VALUES (9,'paxrrizj','2020-11-29 12:19:15','2020-11-30 12:19:15');
/*!40000 ALTER TABLE `password_recovery_codes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_system_data`
--

DROP TABLE IF EXISTS `payment_system_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_system_data` (
  `payment_systems_id` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления записи',
  `data` json NOT NULL,
  PRIMARY KEY (`payment_systems_id`),
  CONSTRAINT `fk_payment_system_data_payment_systems1` FOREIGN KEY (`payment_systems_id`) REFERENCES `users.payment_systems` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_system_data`
--

LOCK TABLES `payment_system_data` WRITE;
/*!40000 ALTER TABLE `payment_system_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment_system_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `social_network_data`
--

DROP TABLE IF EXISTS `social_network_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `social_network_data` (
  `social_networks_id` int NOT NULL,
  `client_id` varchar(255) NOT NULL,
  `client_secret` varchar(255) NOT NULL,
  PRIMARY KEY (`social_networks_id`),
  CONSTRAINT `fk_social_network_data_social_networks1` FOREIGN KEY (`social_networks_id`) REFERENCES `users.social_networks` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `social_network_data`
--

LOCK TABLES `social_network_data` WRITE;
/*!40000 ALTER TABLE `social_network_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `social_network_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_identity_data`
--

DROP TABLE IF EXISTS `user_identity_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_identity_data` (
  `users_id` int NOT NULL,
  `login` varchar(255) NOT NULL,
  `password_hash` varchar(64) NOT NULL,
  `password_salt` varchar(64) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '  ',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '  ',
  PRIMARY KEY (`users_id`),
  UNIQUE KEY `login_UNIQUE` (`login`),
  CONSTRAINT `fk_user_identity_data_users1` FOREIGN KEY (`users_id`) REFERENCES `users`.`users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_identity_data`
--

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-11-29 14:21:40
