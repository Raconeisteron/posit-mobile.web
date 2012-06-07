<?php

require_once("controller/main.php");
require_once("controller/odk.php");
require_once("util/validate.php");

$path = explode("/", $_SERVER["REQUEST_URI"]);
for($n=0; $n<count($path); $n++)
	if($path[$n] == 'odk')
		break;

$p = "";
$i = $n + 1;
while(isset($path[$i])) {
	$p .= "/".$path[$i];
	$i++;
}

odkController($p, $_REQUEST,$_FILES);


?>