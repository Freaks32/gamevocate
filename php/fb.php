<?php
require_once("fbapi/facebook.php");
require_once("fbapi/secret.php");

function fbconnect() {
	global $secret;
	$config = array(
		'appId' => '181513272053296',
		'secret' => $secret,
		'fileUpload' => false, // optional
		'allowSignedRequest' => false, // optional, but should be set to false for non-canvas apps
	);
	$facebook = new Facebook($config);
	return $facebook;
}
?>
