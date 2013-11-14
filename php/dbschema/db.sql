-- MySQL dump 10.13  Distrib 5.5.34, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: gamevocate
-- ------------------------------------------------------
-- Server version	5.5.34-0ubuntu0.13.10.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Classes`
--

DROP TABLE IF EXISTS `Classes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Classes` (
  `classkey` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(128) DEFAULT NULL,
  `permissions` int(11) DEFAULT NULL,
  PRIMARY KEY (`classkey`),
  UNIQUE KEY `classkey` (`classkey`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Classes`
--

LOCK TABLES `Classes` WRITE;
/*!40000 ALTER TABLE `Classes` DISABLE KEYS */;
INSERT INTO `Classes` VALUES (1,'Normal User',0),(2,'Administrator',1);
/*!40000 ALTER TABLE `Classes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GameByStudio`
--

DROP TABLE IF EXISTS `GameByStudio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GameByStudio` (
  `gamekey` int(11) NOT NULL,
  `studkey` int(11) NOT NULL,
  PRIMARY KEY (`gamekey`,`studkey`),
  KEY `studkey` (`studkey`),
  CONSTRAINT `GameByStudio_ibfk_1` FOREIGN KEY (`gamekey`) REFERENCES `Games` (`gamekey`),
  CONSTRAINT `GameByStudio_ibfk_2` FOREIGN KEY (`studkey`) REFERENCES `Studios` (`studkey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GameByStudio`
--

LOCK TABLES `GameByStudio` WRITE;
/*!40000 ALTER TABLE `GameByStudio` DISABLE KEYS */;
INSERT INTO `GameByStudio` VALUES (1,1);
/*!40000 ALTER TABLE `GameByStudio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GameOfGenre`
--

DROP TABLE IF EXISTS `GameOfGenre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GameOfGenre` (
  `gamekey` int(11) NOT NULL,
  `genrekey` int(11) NOT NULL,
  PRIMARY KEY (`gamekey`,`genrekey`),
  KEY `genrekey` (`genrekey`),
  CONSTRAINT `GameOfGenre_ibfk_1` FOREIGN KEY (`gamekey`) REFERENCES `Games` (`gamekey`),
  CONSTRAINT `GameOfGenre_ibfk_2` FOREIGN KEY (`genrekey`) REFERENCES `Genres` (`genrekey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GameOfGenre`
--

LOCK TABLES `GameOfGenre` WRITE;
/*!40000 ALTER TABLE `GameOfGenre` DISABLE KEYS */;
/*!40000 ALTER TABLE `GameOfGenre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Games`
--

DROP TABLE IF EXISTS `Games`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Games` (
  `gamekey` int(11) NOT NULL AUTO_INCREMENT,
  `game_title` char(128) NOT NULL,
  `game_description` varchar(1024) DEFAULT NULL,
  `game_steam_appid` int(11) DEFAULT NULL,
  `avg_rating` float DEFAULT NULL,
  PRIMARY KEY (`gamekey`),
  UNIQUE KEY `gamekey` (`gamekey`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Games`
--

LOCK TABLES `Games` WRITE;
/*!40000 ALTER TABLE `Games` DISABLE KEYS */;
INSERT INTO `Games` VALUES (1,'Team Fortress 2','Free-to-Play First Person Shooter and Hat Collection Simulator',440,NULL),(2,'Left 4 Dead 2','Zombie Apocalypse First Person Co-op Shooter',550,4.5),(3,'Assassin\'s Creed IV: Black Flag','First Person Shooter',242050,NULL),(4,'Call of Duty: Ghosts','',209160,2);
/*!40000 ALTER TABLE `Games` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Genres`
--

DROP TABLE IF EXISTS `Genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Genres` (
  `genrekey` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(32) NOT NULL,
  `description` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`genrekey`),
  UNIQUE KEY `genrekey` (`genrekey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Genres`
--

LOCK TABLES `Genres` WRITE;
/*!40000 ALTER TABLE `Genres` DISABLE KEYS */;
/*!40000 ALTER TABLE `Genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Reviews`
--

DROP TABLE IF EXISTS `Reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Reviews` (
  `gamekey` int(11) NOT NULL,
  `userkey` int(11) NOT NULL,
  `review_title` char(128) DEFAULT NULL,
  `review_body` varchar(2048) DEFAULT NULL,
  `review_rating` int(11) NOT NULL,
  `review_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`gamekey`,`userkey`),
  KEY `userkey` (`userkey`),
  CONSTRAINT `Reviews_ibfk_1` FOREIGN KEY (`gamekey`) REFERENCES `Games` (`gamekey`),
  CONSTRAINT `Reviews_ibfk_2` FOREIGN KEY (`userkey`) REFERENCES `Users` (`userkey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Reviews`
--

LOCK TABLES `Reviews` WRITE;
/*!40000 ALTER TABLE `Reviews` DISABLE KEYS */;
INSERT INTO `Reviews` VALUES (1,2,NULL,NULL,5,'2013-11-13 23:38:44'),(2,2,NULL,NULL,5,'2013-11-14 17:40:49'),(4,3,NULL,NULL,2,'2013-11-14 17:54:16');
/*!40000 ALTER TABLE `Reviews` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER games_update_avg_rating_insert AFTER INSERT ON Reviews
FOR EACH ROW BEGIN
UPDATE Games SET avg_rating = (SELECT AVG(review_rating) FROM Reviews WHERE gamekey = NEW.gamekey) WHERE gamekey = NEW.gamekey;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER games_update_avg_rating_update AFTER UPDATE ON Reviews
FOR EACH ROW BEGIN
UPDATE Games SET avg_rating = (SELECT AVG(review_rating) FROM Reviews where gamekey = NEW.gamekey) where gamekey = NEW.gamekey;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER games_update_avg_rating_delete AFTER DELETE ON Reviews
FOR EACH ROW BEGIN
UPDATE Games SET avg_rating = (SELECT AVG(review_rating) FROM Reviews WHERE gamekey = OLD.gamekey) where gamekey = OLD.gamekey;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Studios`
--

DROP TABLE IF EXISTS `Studios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Studios` (
  `studkey` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(128) DEFAULT NULL,
  `location` char(128) DEFAULT NULL,
  PRIMARY KEY (`studkey`),
  UNIQUE KEY `studkey` (`studkey`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Studios`
--

LOCK TABLES `Studios` WRITE;
/*!40000 ALTER TABLE `Studios` DISABLE KEYS */;
INSERT INTO `Studios` VALUES (1,'Valve','Bellevue, Washington');
/*!40000 ALTER TABLE `Studios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserLikesGenre`
--

DROP TABLE IF EXISTS `UserLikesGenre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UserLikesGenre` (
  `userkey` int(11) NOT NULL,
  `genrekey` int(11) NOT NULL,
  `like_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`userkey`,`genrekey`),
  KEY `genrekey` (`genrekey`),
  CONSTRAINT `UserLikesGenre_ibfk_1` FOREIGN KEY (`genrekey`) REFERENCES `Genres` (`genrekey`),
  CONSTRAINT `UserLikesGenre_ibfk_2` FOREIGN KEY (`userkey`) REFERENCES `Users` (`userkey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserLikesGenre`
--

LOCK TABLES `UserLikesGenre` WRITE;
/*!40000 ALTER TABLE `UserLikesGenre` DISABLE KEYS */;
/*!40000 ALTER TABLE `UserLikesGenre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Users` (
  `userkey` int(11) NOT NULL AUTO_INCREMENT,
  `classkey` int(11) NOT NULL,
  `username` char(128) NOT NULL,
  PRIMARY KEY (`userkey`),
  UNIQUE KEY `userkey` (`userkey`),
  UNIQUE KEY `username` (`username`),
  KEY `classkey` (`classkey`),
  CONSTRAINT `Users_ibfk_1` FOREIGN KEY (`classkey`) REFERENCES `Classes` (`classkey`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (2,2,'Freaks32'),(3,1,'Debug User');
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-11-14 10:03:29
