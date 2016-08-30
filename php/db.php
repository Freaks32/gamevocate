<?php

require_once('mysql.php');

$mysqli = null;

function dbconnect() {
	global $mysqli, $dbhostname, $dbusername, $dbpassword, $dbname, $dbport;

	if($mysqli != null) {
		$mysqli->close();
		$mysqli = null;
	}
	$mysqli = new mysqli($dbhostname, $dbusername, $dbpassword, $dbname, $dbport);
	if($mysqli->connect_errno) {
	}
	return $mysqli;
}

function dbdisconnect() {
	global $mysqli;
	
	if($mysqli != null) {
		$mysqli->close();
		$mysqli = null;
	}
}

?>
