<?php

error_reporting(E_ALL);
mysqli_report(MYSQLI_REPORT_ALL);
//error_reporting(E_ALL & ~E_NOTICE | E_STRICT); // Warns on good coding standards
ini_set("display_errors", "1");

require_once('db.php');
require_once('fb.php');
require_once('priviledges.php');
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

		switch($reviewtype) {
		case 'rating':
			// Rating Only
			$rating = $review['rating'];

			$subresult = checkReviewExists($userkey, $gamekey);
			if($subresult['success']) {
				if($subresult['exists']) {
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
			} else {
				$result['success'] = false;
				$result = addError($result, $subresult);
			}
			break;
		case 'review':
			// Review Only
			$title = $review['title'];
			$body = $review['body'];

			$subresult = checkReviewExists($userkey, $gamekey);
			if($subresult['success']) {
				if($subresult['exists']) {
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
			} else {
				$result['success'] = false;
				$result = addError($result, $subresult);
			}
			break;
		case 'full':
			// Rating & Review
			$rating = $review['rating'];
			$title = $review['title'];
			$body = $review['body'];

			// Allow By Deafult
			$permission = true;
			// If Review requests to Update via Specified Userkey...
			if($review['userkey'] != null) {
				// If Userkey is not Current User's Userkey...
				if($userkey != $review['userkey']) {
					// Deny By Default
					$permission = false;
					// Verify Review Edit Admin Priviledges
					$subresult = checkPermissions($userkey, $PERMISSION_EDIT);
					if($subresult['success']) {
						$permission = true;
						// Override Userkey
						$userkey = $review['userkey'];
					} else {
						$permission = false;
						$result = addError($result, $subresult);
					}
				}
			}

			if($permission) {
				$subresult = checkReviewExists($userkey, $gamekey);
				if($subresult['success']) {
					if($subresult['exists']) {
						// Update when Review Exists
						if($query = $mysqli->prepare("update Reviews set r_rating = ?, r_title = ?, r_body = ? where userkey = ? and gamekey = ?")) {
							$query->bind_param("issii", $rating, $title, $body, $userkey, $gamekey);
							if(!$query->execute()) {
								// If Query fails to execute, Fail Result
								$result['success'] = false;
							}
							$query->close();
						} else {
							die("Unable to Query Database - LINE:" . __LINE__);
						}
					} else {
						$result["INN"] = "DNE";
						// Insert when Review DNE
						if($query = $mysqli->prepare("insert into Reviews (userkey, gamekey, r_rating, r_title, r_body) values (?, ?, ?, ?, ?)")) {
							$query->bind_param("iiiss", $userkey, $gamekey, $rating, $title, $body);					
							if(!$query->execute()) {
								// If Query fails to execute, Fail Result
								$result['success'] = false;
							}
							$result["OUT"] = "CLOSE";
							$query->close();
						} else {
							die("Unable to Query Database - LINE:" . __LINE__);
						}
					}
				} else {
					$result['success'] = false;
					$result = addError($result, $subresult);
				}
			} else {
				$result['success'] = false;
				$result['message'] = "Insufficient User Permission";
			}
			break;
		default:
			die("Unsupported Review Type - LINE:" . __LINE__);
		}
		break;
	case "push_delete_review":
		$ukey = $_POST["userkey"];
		$gkey = $_POST["gamekey"];

		// Allow By Deafult
		$permission = true;
		// If Userkey is not Current User's Userkey...
		if($userkey != $ukey) {
			// Deny By Default
			$permission = false;
			// Verify Review Edit Admin Priviledges
			$subresult = checkPermissions($userkey, $PERMISSION_EDIT);
			if($subresult['success']) {
				$permission = true;
				// Override Userkey
				$userkey = $ukey;
			} else {
				$permission = false;
				$result = addError($result, $subresult);
			}
		}
		if($permission) {
			// Prepare Delete Query
			if($query = $mysqli->prepare("delete from Reviews where userkey = ? and gamekey = ?")) {
				$query->bind_param("ii", $userkey, $gkey);
				if(!$query->execute()) {
					// If Query fails to execute, Fail Result
					$result['success'] = false;
					$result['message'] = "Query Execution Failed";
				}
			} else {
				$result['success'] = false;
				$result['message'] = "Query Preparation Failed";
			}
		} else {
			$result['success'] = false;
			$result['message'] = "Insufficient Permissions";
		}
		break;
	default:
		die("Unknown Query Type - LINE:" . __LINE__);
	}

	echo json_encode($result);
} else {
	die("No Post Data Received");
}

function checkPermissions($userkey, $permission_mask) {
	global $mysqli;

	// Initialize Result Array
	$result = array();
	// Default Successful
	$result['success'] = true;

	if($userkey != null) {
		// If Valid Userkey
		if($query = $mysqli->prepare("select c_permissions from Users natural join Classes where userkey = ?")) {
			// Prepare and Execute Permission Query
			$query->bind_param("i", $userkey);
			$query->execute();
			$query->bind_result($permissions);
			$query->fetch();
			$query->close();
			// Verify Permission
			if($permissions & $permission_mask === $permission_mask) {
				// If Permissions Sufficient, Success
			} else {
				// If Permissions Insufficient, Fail w/ Details
				$result['success'] = false;
				$result['message'] = "Insufficient User Priviledge";
				$result['required'] = $permission_mask;
				$result['permissions'] = $permissions;
			}
		} else {
			// If Fail to Prepare Query, Fail
			$result['success'] = false;
			$result['message'] = "Failed to Prepare Permission Query";
		}
	} else {
		// If Userkey Invalid, Fail
		$result['success'] = false;
		$result['message'] = "Invalid Userkey";
	}
	return $result;
}

function checkReviewExists($userkey, $gamekey) {
	global $mysqli;

	// Initialize Result Array
	$result = array();
	// Default Successful
	$result['success'] = true;

	// Check if Review Already Exists
	if($query = $mysqli->prepare("select gamekey from Reviews where userkey = ? and gamekey = ?")) {
		$query->bind_param("ii", $userkey, $gamekey);
		$query->execute();
		$query->store_result();
		if($query->num_rows === 1) {
			// If Exists, Success Remains True (Successful Query)
			// Exists -> True (Review Exists)
			$result['exists'] = true;
		} else {
			//If DNE, Success Remains True (Successful Query)
			// Exists -> False (Review DNE)
			$result['exists'] = false;
		}
		$query->free_result();
		$query->close();
	} else {
		$result['success'] = false;
		$result['message'] = "Failed to Prepare Query";
	}
	return $result;
}

function addError($result, $subresult) {
	// If Error Array DNE
	if(!is_array($result['errors'])) {
		// Initialize Error Array
		$result['errors'] = array();
	}
	// Append Error Result to Array
	$result[sizeof($result['errors'])] = $subresult;
	// Return Result
	return $result;
}

?>
