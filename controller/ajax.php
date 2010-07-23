<?php

function ajaxController($path, $request) {
	global $smarty, $dao, $error;
	list($reqPath, $queryString) = explode('?', $path);
	$pathParts = explode('/', substr($reqPath,1));
	list($action) = $pathParts;
	
	session_start();
	$authnStatus = checkAuthn();
	if(!isLoggedIn()){
		echo "AUTHN_FAILED";
		die();
	} 
		switch($action) {
			case 'main':
				echo "null";
				break;
			case 'submitForm':
				$data = $request["formData"];
				$userId = $_SESSION["loginId"];
				$title = $data["title"];
				$formData = $data["content"];
				if(!validate_project_name($title)){
					jsonError(TITLE_INVALID, "Your form's name is invalid.");
				}
				if(count($data["content"])>10){
					jsonError(FORM_OVERFLOW, "Your form is too large. 10 controls may be present in a form. You have ".count($data["content"]).".");
				}
				if($dao->checkFormName($title, $userId)){
					jsonError(FORM_NAME_EXISTS, "You already have a form with the same name. Please choose another name.");
				}
				$dao->newForm($title, $userId, $formData);
				break;
			case 'updateForm':
				$data = $request["formData"];
				$userId = $_SESSION["loginId"];
				$title = $data["title"];
				$formData = $data["content"];
				if(count($data["content"])>10){
					jsonError(FORM_OVERFLOW, "Your form is too large. 10 controls may be present in a form. You have ".count($data["content"]).".");
				}
				$dao->updateForm($title, $userId, $formData);
				break;
			case 'listForms':
				$formList = json_encode($dao->listForms($_SESSION["loginId"]));
				echo $formList;						
				break;
			case 'loadForm':
				$data = $request["formData"];
				$title = $data["title"];
				$userId = $_SESSION["loginId"];
				$formData = $dao->loadForm($userId, $title);
				$responseObject = '{"title": "'.$title.'", "description" : "", "owner" : "foo", "controls" :'. $formData.' , "id": "xwfsdfs"}';
				echo $responseObject;
				break;
			case 'username':
				echo $_SESSION["loginEmail"];
				break;
			default:
				header("Location: main");
		}
	
}

?>
