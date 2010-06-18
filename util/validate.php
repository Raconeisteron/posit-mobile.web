<?php

/**
 * used to check validity of email address
 * @param unknown_type $emailString
 */
function validate_email_address($emailString){
	if (strlen($emailString)==0) return false;
	$matches = array();

	if (filter_var($emailString, FILTER_VALIDATE_EMAIL)==$emailString){
		preg_match('/(.+)@(.+)/', $emailString,$matches);
		if (sizeof($matches)!=3){ /*original string + matches*/
			return false;
		}
		if (checkdnsrr($matches[2], "MX")){ // check if there's a MX record in DNS
			return true;
		}else {
			return false;
		}

	}
	return false;
}

?>