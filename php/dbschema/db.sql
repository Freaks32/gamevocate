-- MySQL dump 10.13  Distrib 5.5.31, for debian-linux-gnu (armv7l)
--
-- Host: localhost    Database: gamevocate
-- ------------------------------------------------------
-- Server version	5.5.31-0+wheezy1

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
  `c_name` char(128) DEFAULT NULL,
  `c_permissions` int(11) DEFAULT NULL,
  PRIMARY KEY (`classkey`),
  UNIQUE KEY `classkey` (`classkey`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Table structure for table `Games`
--

DROP TABLE IF EXISTS `Games`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Games` (
  `gamekey` int(11) NOT NULL AUTO_INCREMENT,
  `g_title` char(128) NOT NULL DEFAULT '',
  `g_description` varchar(1024) DEFAULT NULL,
  `g_steamappid` int(11) DEFAULT NULL,
  `g_avgrating` float DEFAULT NULL,
  PRIMARY KEY (`gamekey`),
  UNIQUE KEY `gamekey` (`gamekey`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Genres`
--

DROP TABLE IF EXISTS `Genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Genres` (
  `genrekey` int(11) NOT NULL AUTO_INCREMENT,
  `ge_name` char(32) NOT NULL DEFAULT '',
  `ge_description` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`genrekey`),
  UNIQUE KEY `genrekey` (`genrekey`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Reviews`
--

DROP TABLE IF EXISTS `Reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Reviews` (
  `gamekey` int(11) NOT NULL,
  `userkey` int(11) NOT NULL,
  `r_title` char(128) DEFAULT NULL,
  `r_body` varchar(2048) DEFAULT NULL,
  `r_rating` int(11) NOT NULL,
  `r_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`gamekey`,`userkey`),
  KEY `userkey` (`userkey`),
  CONSTRAINT `Reviews_ibfk_1` FOREIGN KEY (`gamekey`) REFERENCES `Games` (`gamekey`),
  CONSTRAINT `Reviews_ibfk_2` FOREIGN KEY (`userkey`) REFERENCES `Users` (`userkey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER games_update_avgrating_insert AFTER INSERT ON Reviews
FOR EACH ROW BEGIN
UPDATE Games SET g_avgrating = (SELECT AVG(r_rating) FROM Reviews WHERE gamekey = NEW.gamekey) WHERE gamekey = NEW.gamekey;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER games_update_avgrating_update AFTER UPDATE ON Reviews
FOR EACH ROW BEGIN
UPDATE Games SET g_avgrating = (SELECT AVG(r_rating) FROM Reviews WHERE gamekey = NEW.gamekey) WHERE gamekey = NEW.gamekey;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER games_update_avgrating_delete AFTER DELETE ON Reviews
FOR EACH ROW BEGIN
UPDATE Games SET g_avgrating = (SELECT AVG(r_rating) FROM Reviews WHERE gamekey = OLD.gamekey) WHERE gamekey = OLD.gamekey;
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
  `s_name` char(128) DEFAULT NULL,
  `s_location` char(128) DEFAULT NULL,
  PRIMARY KEY (`studkey`),
  UNIQUE KEY `studkey` (`studkey`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `UserLikesGenre`
--

DROP TABLE IF EXISTS `UserLikesGenre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UserLikesGenre` (
  `userkey` int(11) NOT NULL,
  `genrekey` int(11) NOT NULL,
  `l_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`userkey`,`genrekey`),
  KEY `genrekey` (`genrekey`),
  CONSTRAINT `UserLikesGenre_ibfk_1` FOREIGN KEY (`genrekey`) REFERENCES `Genres` (`genrekey`),
  CONSTRAINT `UserLikesGenre_ibfk_2` FOREIGN KEY (`userkey`) REFERENCES `Users` (`userkey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Users` (
  `userkey` int(11) NOT NULL AUTO_INCREMENT,
  `classkey` int(11) NOT NULL,
  `u_username` char(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`userkey`),
  UNIQUE KEY `userkey` (`userkey`),
  UNIQUE KEY `username` (`u_username`),
  KEY `classkey` (`classkey`),
  CONSTRAINT `Users_ibfk_1` FOREIGN KEY (`classkey`) REFERENCES `Classes` (`classkey`)
) ENGINE=InnoDB AUTO_INCREMENT=1338 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-11-18 16:45:47
