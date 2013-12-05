<?php

//error_reporting(E_ALL); 
//error_reporting(E_ALL & ~E_NOTICE | E_STRICT); // Warns on good coding standards
//ini_set("display_errors", "1");

require_once('db.php');

$result = array();
$mysqli = dbconnect();

if($_POST) {
	switch($_POST['type']) {
	case 'query_games':
		$games = array();
		if($query = $mysqli->prepare("select gamekey, g_title, g_description, g_steamappid, g_avgrating from Games")) {
			$query->execute();
			$query->bind_result($gamekey, $g_title, $g_description, $g_steamappid, $g_avgrating);
			$i = 0;
			while($query->fetch()) {
				if($g_steamappid) {
					$g_image = "http://cdn.steampowered.com/v/gfx/apps/" . $g_steamappid . "/header.jpg";
				} else if(file_exists("../images/games/" . $gamekey . ".jpg")) {
					$g_image = "images/games/" . $gamekey . ".jpg";
				} else {
					$g_image = "images/noimage.png";
				}
				$games[$i++] = array(	"gamekey"=>$gamekey,
							"title"=>$g_title,
						 	"description"=>$g_description,
							"image"=>$g_image,
							"avgrating"=>$g_avgrating);
			}
			$query->close();
		}
		$result["games"] = $games;
		break;
	case 'query_gameinfo':
		$gamekey = $_POST['gamekey'];
		$gameinfo = array();
		if($query = $mysqli->prepare("select g_title, g_steamappid, g_description, ge_name from Games natural join GameOfGenre natural join Genres where gamekey = ?")) {
			$query->bind_param("i", $gamekey);
			$query->execute();
			$query->bind_result($g_title, $g_steamappid, $g_description, $ge_name);
			$i = 0;
			$genres = array();
			while($query->fetch()) {
				if($i == 0) {
					$gameinfo["title"] = $g_title;
					if($g_steamappid) {
						$g_image = "http://cdn.steampowered.com/v/gfx/apps/" . $g_steamappid . "/header.jpg";
					} else if(file_exists("../images/games/" . $gamekey . ".jpg")) {
						$g_image = "images/games/" . $gamekey . ".jpg";
					} else {
						$g_image = "images/noimage.png";
					}
					$gameinfo["image"] = $g_image;
					$gameinfo["description"] = $g_description;
				}
				$genres[$i] = $ge_name;
				$i++;
			}
			$gameinfo["genres"] = $genres;
			$query->close();
		}
		$result["gameinfo"] = $gameinfo;
		break;
	case 'query_gamerating':
		$gamekey = $_POST['gamekey'];
		if($query = $mysqli->prepare("select g_avgrating from Games where gamekey = ?")) {
			$query->bind_param("i", $gamekey);
			$query->execute();
			$query->bind_result($rating);
			$query->fetch();
			$query->close();
		}
		$result["rating"] = $rating;
		break;
	default:
		die("Unknown Query Type");
	}
	echo json_encode($result);
} else {
	die("No Post Data Received");
}

?>
