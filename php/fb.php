<?php
require_once("fbapi/facebook.php");

function fbconnect() {
	$config = array(
		'appId' => '181513272053296',
		'secret' => '788e017cc0831205296c76b5fd2d24df',
		'fileUpload' => false, // optional
		'allowSignedRequest' => false, // optional, but should be set to false for non-canvas apps
	);
	$facebook = new Facebook($config);
	return $facebook;
}
?>
