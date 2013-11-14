<?php

//error_reporting(E_ALL); 
//error_reporting(E_ALL & ~E_NOTICE | E_STRICT); // Warns on good coding standards
//ini_set("display_errors", "1");

require_once('db.php');

$mysqli = dbconnect();

if($_POST) {
	switch($_POST['type']) {
	case 'query_game':
		if($query = $mysqli->prepare("select game_title, game_description, game_steam_appid from Games")) {
			$query->execute();
			$query->bind_result($game_title, $game_description, $game_steam_appid);
			$i = 0;
			$games = array();
			while($query->fetch()) {
				if($game_steam_appid) {
					$game_image = "http://cdn.steampowered.com/v/gfx/apps/" . $game_steam_appid . "/header.jpg";
				}
				$games[$i++] = array(	"title"=>$game_title,
						 	"description"=>$game_description,
							"image"=>$game_image);
			}
			$query->close();
		}
		echo json_encode($games);
		break;
	default:
		die("Unknown Query Type");
	}
} else {
	die("No Post Data Received");
}

?>
