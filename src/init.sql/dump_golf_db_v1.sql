USE golf_db; -- Add this line to specify the database
-- MySQL dump 10.13  Distrib 8.3.0, for Win64 (x86_64)
--
-- Host: localhost    Database: golf_db
-- ------------------------------------------------------
-- Server version	8.3.0

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
-- Table structure for table `league`
--

DROP TABLE IF EXISTS `league`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `league` (
  `LeagueID` int NOT NULL AUTO_INCREMENT,
  `LeagueName` varchar(255) NOT NULL,
  PRIMARY KEY (`LeagueID`)
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `league`
--

LOCK TABLES `league` WRITE;
/*!40000 ALTER TABLE `league` DISABLE KEYS */;
INSERT INTO `league` VALUES (1,'Team 1');
/*!40000 ALTER TABLE `league` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `players`
--

DROP TABLE IF EXISTS `players`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `players` (
  `PlayerID` int NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(255) DEFAULT NULL,
  `LastName` varchar(255) DEFAULT NULL,
  `Handicap` int NOT NULL,
  `LeagueID` int DEFAULT NULL,
  PRIMARY KEY (`PlayerID`),
  KEY `fk_players_league` (`LeagueID`)
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `players`
--

/*LOCK TABLES `players` WRITE;*/
/*!40000 ALTER TABLE `players` DISABLE KEYS */;
/*INSERT INTO `players` VALUES (75,'Robert','Orosz',2,78);*/
/*!40000 ALTER TABLE `players` ENABLE KEYS */;
/*UNLOCK TABLES;*/

--
-- Table structure for table `scores`
--

DROP TABLE IF EXISTS `scores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scores` (
  `ScoreID` int NOT NULL AUTO_INCREMENT,
  `PlayerID` int DEFAULT NULL,
  `Score` int NOT NULL,
  `Date` date NOT NULL,
  `TeeboxID` int DEFAULT NULL,
  PRIMARY KEY (`ScoreID`),
  KEY `fk_scores_players` (`PlayerID`),
  CONSTRAINT `fk_scores_players` FOREIGN KEY (`PlayerID`) REFERENCES `players` (`PlayerID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scores`
--

/*LOCK TABLES `scores` WRITE;*/
/*!40000 ALTER TABLE `scores` DISABLE KEYS */;
/*INSERT INTO `scores` VALUES (51,75,41,'2025-02-05',1);*/
/*!40000 ALTER TABLE `scores` ENABLE KEYS */;
/*UNLOCK TABLES;*/

--
-- Table structure for table `teeboxes`
--

DROP TABLE IF EXISTS `teeboxes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teeboxes` (
  `TeeboxID` int NOT NULL AUTO_INCREMENT,
  `TeeboxName` varchar(50) NOT NULL,
  `SlopeRating` int NOT NULL,
  `CourseRating` decimal(5,2) NOT NULL,
  `Par` int NOT NULL,
  PRIMARY KEY (`TeeboxID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teeboxes`
--

LOCK TABLES `teeboxes` WRITE;
/*!40000 ALTER TABLE `teeboxes` DISABLE KEYS */;
INSERT INTO `teeboxes` VALUES (1,'Blue, Front 9',63,34.80,35),(2,'Blue, Back 9',63,34.80,36),(3,'White, Front 9',59,33.30,35),(4,'White, Back 9',59,33.30,36),(5,'Silver, Front 9',57,32.90,35),(6,'Silver, Back 9',57,32.90,36),(7,'Gold, Front 9',55,32.50,35),(8,'Gold, Back 9',55,32.50,36);
/*!40000 ALTER TABLE `teeboxes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-05 16:07:16
