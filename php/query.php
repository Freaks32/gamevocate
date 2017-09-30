<?php

//error_reporting(E_ALL); 
//error_reporting(E_ALL & ~E_NOTICE | E_STRICT); // Warns on good coding standards
//ini_set("display_errors", "1");

require_once('db.php');
require_once('fb.php');
require_once('priviledges.php');
$result = array();
$mysqli = dbconnect();
$fb = fbconnect();

if($fbuid = $fb->getUser()) {
	if($query = $mysqli->prepare("select userkey, u_username, c_permissions from Users natural join Classes where u_fbuid = ?")) {
		$query->bind_param("s", $fbuid);
		$query->execute();
		// Bind to $g_userkey, and $g_permissions to differentiate variables
		$query->bind_result($g_userkey, $g_username, $g_permissions);
		$query->fetch();
		$query->close();
	} else {
		$g_userkey = -1;
		$g_username = null;
		$g_permission = 0;
	}
} else {
	$g_userkey = -1;
	$g_username = null;
	$g_permission = 0;
}

if($_POST) {
	switch($_POST['type']) {
	case 'query_genres':
		$genres = array();
		if($query = $mysqli->prepare("select genrekey, ge_name, ge_description from Genres")) {
			$query->execute();
			$query->bind_result($genrekey, $ge_name, $ge_description);
			$i = 0;
			while($query->fetch()) {
				$genres[$i++] = array(	"genrekey"=>$genrekey,
							"name"=>$ge_name,
							"description"=>$ge_description,
							"liked"=>false);
			}
			$query->close();
		}
		if($query = $mysqli->prepare("select genrekey from UserLikesGenre natural join Users where userkey = ?")) {
			$query->bind_param("i", $g_userkey);	
			$query->execute();
			$query->bind_result($genrekey);
			$i = 0;
			while($query->fetch()) {
				$likes[$genrekey] = true;
			}
			$query->close();
		}
		for($i = 0; $i < sizeof($genres); $i++) {
			$genres[$i]["liked"] = $likes[$genres[$i]["genrekey"]];
		}
		$result["genres"] = $genres;
		break;
	case 'query_games':
		$games = array();
		if($query = $mysqli->prepare("select gamekey, g_title, g_description, g_steamappid, g_avgrating from Games")) {
			$query->execute();
			$query->bind_result($gamekey, $g_title, $g_description, $g_steamappid, $g_avgrating);
			$i = 0;
			while($query->fetch()) {
				if($g_steamappid) {
					$g_image = "http://cdn.edgecast.steamstatic.com/steam/apps/" . $g_steamappid . "/header.jpg";
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
						$g_image = "http://cdn.edgecast.steamstatic.com/steam/apps/" . $g_steamappid . "/header.jpg";
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
			$gameinfo["gamekey"] = $gamekey;
			$gameinfo["genres"] = $genres;
			$query->close();
		}
		if($query = $mysqli->prepare("select s_name from Studios natural join GameByStudio where gamekey = ?")) {
			$query->bind_param("i", $gamekey);
			$query->execute();	
			$query->bind_result($s_name);
			$i = 0;
			$studios = array();
			while($query->fetch()) {
				$studios[$i++] = $s_name;
			}
			$gameinfo["studios"] = $studios;
			$query->close();
		}
		if($query = $mysqli->prepare("select r_title, r_body, r_rating, r_timestamp, userkey, u_username from Reviews natural join Users where gamekey = ? and userkey <> ?")) {
			$query->bind_param("ii", $gamekey, $g_userkey);
			$query->execute();
			$query->bind_result($r_title, $r_body, $r_rating, $r_timestamp, $userkey, $u_username);
			$i = 0;
			$reviews = array();
			while($query->fetch()) {
				$review = array();
				$review["title"] = $r_title;
				$review["body"] = $r_body;
				$review["rating"] = $r_rating;
				$review["timestamp"] = $r_timestamp;
				$review["userkey"] = $userkey;
				$review["username"] = $u_username;
				// If Edit Admin Permission
				if($g_permissions & $PERMISSION_EDIT) {
					$review["edit"] = true;
				} else {
					$review["edit"] = false;
				}
				$reviews[$i] = $review;
				$i++;
			}
			$gameinfo["reviews"] = $reviews;
			$query->close();
		}
		if($query = $mysqli->prepare("select r_title, r_body, r_rating, r_timestamp, userkey, u_username from Reviews natural join Users where gamekey = ? and userkey = ?")) {
			$query->bind_param("ii", $gamekey, $g_userkey);
			$query->execute();
			$query->bind_result($r_title, $r_body, $r_rating, $r_timestamp, $userkey, $u_username);
			$i = 0;
			$userreview = array();
			if($query->fetch()) {
				$userreview["title"] = $r_title;
				$userreview["body"] = $r_body;
				$userreview["rating"] = $r_rating;
				$userreview["timestamp"] = $r_timestamp;
				$userreview["userkey"] = $userkey;
				$userreview["username"] = $u_username;
				$userreview["edit"] = true;
			} else {
				$userreview["userkey"] = $g_userkey;
				$userreview["username"] = $g_username;
				$userreview["edit"] = true;
			}
			$gameinfo["userreview"] = $userreview;
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
