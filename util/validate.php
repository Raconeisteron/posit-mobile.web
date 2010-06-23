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

/**
 * Validates project name for safe string.
 * @param unknown_type $projectName
 */
function validate_project_name($projectName){
	if (strlen($projectName)== 0) return false;
	return preg_match('/^[a-zA-Z0-9\s._\-]+$/', $projectName);
}
/**
 * sanitize textfield, add more checks as needed
 * @param $textField
 */
function sanitize_text_field($textField){
	return mysql_escape_string($textField);
}
?>