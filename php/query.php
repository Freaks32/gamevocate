<?php

error_reporting(E_ALL); 
//error_reporting(E_ALL & ~E_NOTICE | E_STRICT); // Warns on good coding standards
ini_set("display_errors", "1");

require_once('db.php');

$mysqli = dbconnect();

if($_POST) {
	switch($_POST['type']) {
	case 'query_game':
		if($query = $mysqli->prepare("select g_title, g_description, g_steamappid from Games")) {
			$query->execute();
			$query->bind_result($g_title, $g_description, $g_steamappid);
			$i = 0;
			$games = array();
			while($query->fetch()) {
				if($g_steamappid) {
					$g_image = "http://cdn.steampowered.com/v/gfx/apps/" . $g_steamappid . "/header.jpg";
				} else {
					$g_image = "";
				}
				$games[$i++] = array(	"title"=>$g_title,
						 	"description"=>$g_description,
							"image"=>$g_image);
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
