<?php


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

$emails = array( "test@example.com"=>false, 
	"test"=> false, 
	"prasanna@hfoss.org" => true,
	"pgautam@cs.trincoll.edu" => true,
	"trolll+4@gmail.com"=>true,
	"robert');drop table students;"=>false
);

//var_dump(checkdnsrr("example.com", "MX"));
//var_dump(checkdnsrr("gmail.com", "MX"));

$success = 0;
$fail = 0;

foreach ($emails as $email=>$expected_result){
	//var_dump(filter_var($email, FILTER_VALIDATE_EMAIL));

	$result = validate_email_address($email);
	//print "$email => ".var_dump($result)."\n ";
	if ($result == $expected_result){
		$success++;
	}else{
		$fail++;
	}
}

print "success = ".$success."  "." fail =". $fail."\n";
