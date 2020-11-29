-- MySQL dump 10.13  Distrib 8.0.22, for Linux (x86_64)
--
-- Host: localhost    Database: users
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
-- Table structure for table `active_subscriptions`
--

DROP TABLE IF EXISTS `active_subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `active_subscriptions` (
  `subscription_plans_id` int NOT NULL,
  `users_id` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления записи',
  `started_at` datetime NOT NULL COMMENT 'Дата начала подписки',
  `ended_at` datetime NOT NULL COMMENT 'Дата окончания подписки',
  PRIMARY KEY (`subscription_plans_id`,`users_id`),
  KEY `fk_acitve_subscriptions_users1_idx` (`users_id`),
  CONSTRAINT `fk_acitve_subscriptions_subscription_plans1` FOREIGN KEY (`subscription_plans_id`) REFERENCES `subscription_plans` (`id`),
  CONSTRAINT `fk_acitve_subscriptions_users1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_subscriptions`
--

LOCK TABLES `active_subscriptions` WRITE;
/*!40000 ALTER TABLE `active_subscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `active_subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `avatar_sizes`
--

DROP TABLE IF EXISTS `avatar_sizes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `avatar_sizes` (
  `width` tinyint NOT NULL,
  `height` tinyint NOT NULL,
  `alias` varchar(255) NOT NULL COMMENT 'Алиас для урла типа 200x200',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления записи',
  PRIMARY KEY (`width`,`height`),
  UNIQUE KEY `alias_UNIQUE` (`alias`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Размеры аватаров';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `avatar_sizes`
--

LOCK TABLES `avatar_sizes` WRITE;
/*!40000 ALTER TABLE `avatar_sizes` DISABLE KEYS */;
/*!40000 ALTER TABLE `avatar_sizes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `balance_operation_logs`
--

DROP TABLE IF EXISTS `balance_operation_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `balance_operation_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `balance_operations_id` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `data` json NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_balance_operation_data_balance_operations1_idx` (`balance_operations_id`),
  CONSTRAINT `fk_balance_operation_data_balance_operations1` FOREIGN KEY (`balance_operations_id`) REFERENCES `balance_operations` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Лог балансовой операции';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `balance_operation_logs`
--

LOCK TABLES `balance_operation_logs` WRITE;
/*!40000 ALTER TABLE `balance_operation_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `balance_operation_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `balance_operation_statuses`
--

DROP TABLE IF EXISTS `balance_operation_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `balance_operation_statuses` (
  `id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Статус балансовой операции: 1 - new, 2 - processing, 3 - completed';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `balance_operation_statuses`
--

LOCK TABLES `balance_operation_statuses` WRITE;
/*!40000 ALTER TABLE `balance_operation_statuses` DISABLE KEYS */;
/*!40000 ALTER TABLE `balance_operation_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `balance_operation_types`
--

DROP TABLE IF EXISTS `balance_operation_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `balance_operation_types` (
  `id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Тип балансовой операции: 1 - депозит, 2 - вывод, 3 - положительная балансовая коррекция, 4 - отрицательная балансовая коррекция\n';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `balance_operation_types`
--

LOCK TABLES `balance_operation_types` WRITE;
/*!40000 ALTER TABLE `balance_operation_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `balance_operation_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `balance_operations`
--

DROP TABLE IF EXISTS `balance_operations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `balance_operations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `amount` decimal(10,2) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления записи',
  `balance_operation_statuses_id` int NOT NULL,
  `balance_operation_types_id` int NOT NULL,
  `payment_systems_id` int NOT NULL,
  `users_id` int NOT NULL,
  `wallet` varchar(255) DEFAULT NULL COMMENT 'Кошелёк клиента, с которым проводилась операция',
  `completed_at` datetime DEFAULT NULL,
  `comission_amount` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_balance_operations_balance_operation_statuses1_idx` (`balance_operation_statuses_id`),
  KEY `fk_balance_operations_balance_operation_types1_idx` (`balance_operation_types_id`),
  KEY `fk_balance_operations_payment_systems1_idx` (`payment_systems_id`),
  KEY `fk_balance_operations_users1_idx` (`users_id`),
  CONSTRAINT `fk_balance_operations_balance_operation_statuses1` FOREIGN KEY (`balance_operation_statuses_id`) REFERENCES `balance_operation_statuses` (`id`),
  CONSTRAINT `fk_balance_operations_balance_operation_types1` FOREIGN KEY (`balance_operation_types_id`) REFERENCES `balance_operation_types` (`id`),
  CONSTRAINT `fk_balance_operations_payment_systems1` FOREIGN KEY (`payment_systems_id`) REFERENCES `payment_systems` (`id`),
  CONSTRAINT `fk_balance_operations_users1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Балансовые операции';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `balance_operations`
--

LOCK TABLES `balance_operations` WRITE;
/*!40000 ALTER TABLE `balance_operations` DISABLE KEYS */;
/*!40000 ALTER TABLE `balance_operations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `registration_methods`
--

DROP TABLE IF EXISTS `registration_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `registration_methods` (
  `id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Способ регистрации: форма социальные сети';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registration_methods`
--

LOCK TABLES `registration_methods` WRITE;
/*!40000 ALTER TABLE `registration_methods` DISABLE KEYS */;
INSERT INTO `registration_methods` VALUES (1,'form'),(2,'social_network');
/*!40000 ALTER TABLE `registration_methods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `social_networks`
--

DROP TABLE IF EXISTS `social_networks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `social_networks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Социальные сети для регистрации и логина';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `social_networks`
--

LOCK TABLES `social_networks` WRITE;
/*!40000 ALTER TABLE `social_networks` DISABLE KEYS */;
/*!40000 ALTER TABLE `social_networks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscription_plan_features`
--

DROP TABLE IF EXISTS `subscription_plan_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscription_plan_features` (
  `id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `subscription_plans_id` int NOT NULL,
  PRIMARY KEY (`id`,`subscription_plans_id`),
  KEY `fk_subscription_plan_features_subscription_plans1_idx` (`subscription_plans_id`),
  CONSTRAINT `fk_subscription_plan_features_subscription_plans1` FOREIGN KEY (`subscription_plans_id`) REFERENCES `subscription_plans` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Доступные возможности в плане';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscription_plan_features`
--

LOCK TABLES `subscription_plan_features` WRITE;
/*!40000 ALTER TABLE `subscription_plan_features` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscription_plan_features` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscription_plans`
--

DROP TABLE IF EXISTS `subscription_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscription_plans` (
  `id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `price` decimal(12,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Планы подписки';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscription_plans`
--

LOCK TABLES `subscription_plans` WRITE;
/*!40000 ALTER TABLE `subscription_plans` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscription_plans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscriptions`
--

DROP TABLE IF EXISTS `subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscriptions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `users_id` int NOT NULL,
  `subscription_plans_id` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `price` decimal(12,2) NOT NULL COMMENT 'Стоимость из subscription_plans',
  `title` varchar(255) NOT NULL COMMENT 'Название плана из subscription_plans',
  `started_at` datetime NOT NULL COMMENT 'Дата начала подписки',
  `ended_at` datetime NOT NULL COMMENT 'Дата окончания подписки',
  PRIMARY KEY (`id`),
  KEY `fk_subscriptions_users1_idx` (`users_id`),
  KEY `fk_subscriptions_subscription_plans1_idx` (`subscription_plans_id`),
  CONSTRAINT `fk_subscriptions_subscription_plans1` FOREIGN KEY (`subscription_plans_id`) REFERENCES `subscription_plans` (`id`),
  CONSTRAINT `fk_subscriptions_users1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Подписки';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscriptions`
--

LOCK TABLES `subscriptions` WRITE;
/*!40000 ALTER TABLE `subscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_avatars`
--

DROP TABLE IF EXISTS `user_avatars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_avatars` (
  `users_id` int NOT NULL,
  `avatar_sizes_width` tinyint NOT NULL,
  `avatar_sizes_height` tinyint NOT NULL,
  `location` varchar(255) NOT NULL,
  `server` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления записи',
  PRIMARY KEY (`users_id`,`avatar_sizes_width`,`avatar_sizes_height`),
  KEY `fk_user_avatars_avatar_sizes1_idx` (`avatar_sizes_width`,`avatar_sizes_height`),
  CONSTRAINT `fk_user_avatars_avatar_sizes1` FOREIGN KEY (`avatar_sizes_width`, `avatar_sizes_height`) REFERENCES `avatar_sizes` (`width`, `height`),
  CONSTRAINT `fk_user_avatars_users1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_avatars`
--

LOCK TABLES `user_avatars` WRITE;
/*!40000 ALTER TABLE `user_avatars` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_avatars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_logs`
--

DROP TABLE IF EXISTS `user_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `users_id` int NOT NULL,
  `data` json NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_user_logs_users1_idx` (`users_id`),
  CONSTRAINT `fk_user_logs_users1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Логи пользователей';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_logs`
--

LOCK TABLES `user_logs` WRITE;
/*!40000 ALTER TABLE `user_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_social_networks`
--

DROP TABLE IF EXISTS `user_social_networks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_social_networks` (
  `social_networks_id` int NOT NULL,
  `users_id` int NOT NULL,
  `login` varchar(255) NOT NULL,
  PRIMARY KEY (`social_networks_id`,`users_id`),
  KEY `fk_user_social_networks_users1_idx` (`users_id`),
  CONSTRAINT `fk_user_social_networks_social_networks1` FOREIGN KEY (`social_networks_id`) REFERENCES `social_networks` (`id`),
  CONSTRAINT `fk_user_social_networks_users1` FOREIGN KEY (`users_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_social_networks`
--

LOCK TABLES `user_social_networks` WRITE;
/*!40000 ALTER TABLE `user_social_networks` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_social_networks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_statuses`
--

DROP TABLE IF EXISTS `user_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_statuses` (
  `id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Статус пользователя: 0 - новый, 1 - активирован, 2 - отключен\n';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_statuses`
--

LOCK TABLES `user_statuses` WRITE;
/*!40000 ALTER TABLE `user_statuses` DISABLE KEYS */;
INSERT INTO `user_statuses` VALUES (1,'new'),(2,'active'),(3,'disabled');
/*!40000 ALTER TABLE `user_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `public_name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания записи',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления записи',
  `last_loggedin_at` datetime DEFAULT NULL COMMENT 'Последний раз входил',
  `registration_methods_id` int NOT NULL,
  `user_statuses_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_users_registration_methods1_idx` (`registration_methods_id`),
  KEY `fk_users_user_statuses1_idx` (`user_statuses_id`),
  CONSTRAINT `fk_users_registration_methods1` FOREIGN KEY (`registration_methods_id`) REFERENCES `registration_methods` (`id`),
  CONSTRAINT `fk_users_user_statuses1` FOREIGN KEY (`user_statuses_id`) REFERENCES `user_statuses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Пользователи';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-11-29 14:21:50
