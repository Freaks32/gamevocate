<?php
require_once("fbapi/facebook.php");

$config = array(
	'appId' => '181513272053296',
	'secret' => '',
	'fileUpload' => false, // optional
	'allowSignedRequest' => false, // optional, but should be set to false for non-canvas apps
);

$facebook = new Facebook($config);

echo $facebook->getUser();
echo "<br />";
echo $facebook->api('/me');
?>
