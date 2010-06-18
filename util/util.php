<?php
/**
 * generate authentication key of length 16
 * @param unknown_type $length
 * @return unknown_type
 */
function genAuthKey($length = 16) {
	$k = "";
	$chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
	
	for($n=0; $n<$length; $n++)
		$k .= $chars {
			rand(0, strlen($chars))
		};
	return $k;
}


function sendEmail($to, $subject, $message){
	mail($to, $subject, $message, "Content-Type: text/html; charset=iso-8859-1");
}

?>
