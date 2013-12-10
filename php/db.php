<?php

$dbhostname = 'localhost';
$dbusername = 'gamevocate';
$dbpassword = '***REMOVED***';
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
