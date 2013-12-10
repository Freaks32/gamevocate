<?php

//error_reporting(E_ALL); 
//error_reporting(E_ALL & ~E_NOTICE | E_STRICT); // Warns on good coding standards
//ini_set("display_errors", "1");

require_once('db.php');

$result = array();
$mysqli = dbconnect();

if($_POST) {
	switch($_POST['type']) {
	case 'create_acct':
		if($query = $mysqli->prepare("insert into Users (classkey, u_username, u_fbuid) values (?, ?, ?)")) {
			$classkey = 2;
			$username = $_POST['username'];
			$fbuid = $_POST['fbuid'];
			$query->bind_param("iss", $classkey, $username, $fbuid);			
			$result["success"] = $query->execute();
			$query->close();
		} else {
			$result["success"] = false;
			$result["message"] = "QUERY FAIL";
		}
		$result["type"] = gettype($fbuid);
		echo json_encode($result);
		break;
	default:
	}
} else {
}

?>
