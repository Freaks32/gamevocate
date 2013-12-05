<?php

error_reporting(E_ALL);
mysqli_report(MYSQLI_REPORT_ALL);
//error_reporting(E_ALL & ~E_NOTICE | E_STRICT); // Warns on good coding standards
ini_set("display_errors", "1");

require_once('db.php');
require_once('fb.php');
$result = array();
$mysqli = dbconnect();
$fb = fbconnect();

if($fbuid = $fb->getUser()) {
	if($query = $mysqli->prepare("select userkey from Users where u_fbuid = ?")) {
		$query->bind_param("s", $fbuid);
		$query->execute();
		$query->bind_result($userkey);
		$query->fetch();
		$query->close();
	} else {
		die("Unable to Identify User");
	}
} else {
	die("User's Facebook Not Connected");
}

if($_POST) {
	// Default Successful Result
	$result['success'] = true;

	// Determine Push Type
	switch($_POST['type']) {
	case 'push_review':
		$review = $_POST['review'];
		$gamekey = $review['gamekey'];
		$reviewtype = $review['type'];

		$update = false;
		// Check if Reviewer has already reviewed game
		if($query = $mysqli->prepare("select gamekey from Reviews where userkey = ? and gamekey = ?")) {
			$query->bind_param("ii", $userkey, $gamekey);
			$query->execute();
			$query->store_result();
			if($query->num_rows > 0) {
				$update = true;
			}
			$query->free_result();
			$query->close();
		} else {
			die("Unable to Query Database - LINE:" . __LINE__);
		}

		switch($reviewtype) {
		case 'rating':
			// Rating Only
			$rating = $review['rating'];

			if($update) {
				// Update when Review Exists
				if($query = $mysqli->prepare("update Reviews set r_rating = ? where userkey = ? and gamekey = ?")) {
					$query->bind_param("iii", $rating, $userkey, $gamekey);
					if(!$query->execute()) {
						// If Query fails to execute, Fail Result
						$result['success'] = false;
					}
					$query->close();
				} else {
					die("Unable to Query Database - LINE:" . __LINE__);
				}
			} else {
				// Insert when Review DNE
				if($query = $mysqli->prepare("insert into Reviews (userkey, gamekey, r_rating) values (?, ?, ?)")) {
					$query->bind_param("iii", $userkey, $gamekey, $rating);
					if(!$query->execute()) {
						// If Query fails to execute, Fail Result
						$result['success'] = false;
					}
					$query->close();
				} else {
					die("Unable to Query Database - LINE:" . __LINE__);
				}
			}
			break;
		case 'review':
			// Review Only
			$title = $review['title'];
			$body = $review['body'];

			if($update) {
				// Update when Review Exists
				if($query = $mysqli->prepare("update Reviews set r_title = ?, r_body = ? where userkey = ? and gamekey = ?")) {
					$query->bind_param("ssii", $title, $body, $userkey, $gamekey);
					if(!$query->execute()) {
						// If Query fails to execute, Fail Result
						$result['success'] = false;
					}
				} else {
					die("Unable to Query Database - LINE:" . __LINE__);
				}
			} else {
				// Insert when Review DNE
				if($query = $mysqli->prepare("insert into Reviews (userkey, gamekey, r_title, r_body) values (?, ?, ?, ?)")) {
					$query->bind_param("iiss", $userkey, $gamekey, $title, $body);					
					if(!$query->execute()) {
						// If Query fails to execute, Fail Result
						$result['success'] = false;
					}
				} else {
					die("Unable to Query Database - LINE:" . __LINE__);
				}
			}
			break;
		default:
			die("Unsupport Review Type - LINE:" . __LINE__);
		}
		break;
	default:
		die("Unknown Query Type - LINE:" . __LINE__);
	}

	echo json_encode($result);
} else {
	die("No Post Data Received");
}

?>
