<?php

$dbhostname = 'localhost';
$dbusername = 'gamevocate';
$dbpassword = 'zSY2hD53D23hrcbPMW3mD5fM';
$dbname = 'gamevocate';

$mysqli = null;

function dbconnect() {
	global $mysqli, $dbhostname, $dbusername, $dbpassword, $dbname;

	if($mysqli != null) {
		$mysqli->close();
		$mysqli = null;
	}
	$mysqli = new mysqli($dbhostname, $dbusername, $dbpassword, $dbname);
	if($mysqli->connect_errno) {
		die("Failed to connect to database server with Error #" . $mysqli->connect_errno);
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
