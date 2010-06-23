<?php

function message($messageCode, $messageBody){
	return array("messageCode"=>$messageCode, "message" => $messageBody);
}

function jsonMessage($messageCode,  $messageBody){
	echo json_encode(message($messageCode,$messageBody));
}



?>
