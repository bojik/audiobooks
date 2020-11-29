-- MySQL dump 10.13  Distrib 8.0.22, for Linux (x86_64)
--
-- Host: localhost    Database: common
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
-- Table structure for table `error_codes`
--

DROP TABLE IF EXISTS `error_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `error_codes` (
  `code` int NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`code`),
  CONSTRAINT `error_codes_chk_1` CHECK ((`code` >= 45000))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `error_codes`
--

LOCK TABLES `error_codes` WRITE;
/*!40000 ALTER TABLE `error_codes` DISABLE KEYS */;
INSERT INTO `error_codes` VALUES (45000,'Unknown error'),(45001,'Login has been already registered'),(45002,'Password is too short'),(45003,'Password is too simple'),(45004,'JSON schema has not been found'),(45005,'Invalid json data'),(45006,'Invalid login or password'),(45007,'User has not been found'),(45008,'User login or password recovery code is not correct');
/*!40000 ALTER TABLE `error_codes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `json_schemas`
--

DROP TABLE IF EXISTS `json_schemas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `json_schemas` (
  `name` varchar(20) NOT NULL,
  `description` varchar(255) NOT NULL,
  `json_schema` text NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `json_schemas`
--

LOCK TABLES `json_schemas` WRITE;
/*!40000 ALTER TABLE `json_schemas` DISABLE KEYS */;
INSERT INTO `json_schemas` VALUES ('user_register','Schema for user data','\n{\n  \"$id\": \"https://audiobooks/user.schema.json\",\n  \"$schema\": \"http://json-schema.org/draft-07/schema#\",\n  \"title\": \"User\",\n  \"type\": \"object\",\n  \"properties\": {\n    \"public_name\": {\n      \"type\": \"string\",\n      \"description\": \"The user\'s public name.\",\n      \"minLength\": 6,\n      \"maxLength\": 20,\n      \"pattern\": \"^[a-zA-Z0-9]{6, 20}$\"\n    },\n    \"registration_methods_id\": {\n      \"description\": \"ID from table \'registration_methods\'\",\n      \"type\": \"integer\",\n      \"minimum\": 1,\n      \"maximum\": 2\n    }\n  },\n  \"required\": [\"public_name\", \"registration_methods_id\"]\n}        \n        ');
/*!40000 ALTER TABLE `json_schemas` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-11-29 14:21:26
