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
  CONSTRAINT `GameByStudio_ibfk_2` FOREIGN KEY (`studkey`) REFERENCES `Studios` (`studkey`),
  CONSTRAINT `GameByStudio_ibfk_1` FOREIGN KEY (`gamekey`) REFERENCES `Games` (`gamekey`)
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
  CONSTRAINT `GameOfGenre_ibfk_2` FOREIGN KEY (`genrekey`) REFERENCES `Genres` (`genrekey`),
  CONSTRAINT `GameOfGenre_ibfk_1` FOREIGN KEY (`gamekey`) REFERENCES `Games` (`gamekey`)
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
  `game_title` char(128) NOT NULL,
  `game_description` varchar(1024) DEFAULT NULL,
  `game_steam_appid` int(11) DEFAULT NULL,
  PRIMARY KEY (`gamekey`),
  UNIQUE KEY `gamekey` (`gamekey`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-11-13 15:56:39
