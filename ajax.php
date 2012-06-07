<?php

require_once("controller/main.php");
require_once("controller/ajax.php");
require_once("util/validate.php");

$path = explode("/", $_SERVER["REQUEST_URI"]);
for($n=0; $n<count($path); $n++)
	if($path[$n] == 'ajax')
		break;

$p = "";
$i = $n + 1;
while(isset($path[$i])) {
	$p .= "/".$path[$i];
	$i++;
}

ajaxController($p, $_REQUEST);


?>