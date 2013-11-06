<?php

error_reporting(E_ALL); 
//error_reporting(E_ALL & ~E_NOTICE | E_STRICT); // Warns on good coding standards
ini_set("display_errors", "1");

require_once('db.php');

$mysqli = dbconnect();

if($_POST) {
	switch($_POST['type']) {
	case 'game':
		break;
	default:
		die("Unknown Query Type");
	}
} else {
	die("No Post Data Received");
}

?>
