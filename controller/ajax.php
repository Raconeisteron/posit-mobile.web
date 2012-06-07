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
				$xml = $request["xml"];
				if(!validate_project_name($title)){
					jsonError(TITLE_INVALID, "Your form's name is invalid.");
				}
				if(count($data["content"])>10){
					jsonError(FORM_OVERFLOW, "Your form is too large. 10 controls may be present in a form. You have ".count($data["content"]).".");
				}
				if($dao->checkFormName($title, $userId)){
					jsonError(FORM_NAME_EXISTS, "You already have a form with the same name. Please choose another name.");
				}
				$dao->newForm($title, $userId, $formData, $xml);
				break;
			case 'updateForm':
				$data = $request["formData"];
				$userId = $_SESSION["loginId"];
				$title = $data["title"];
				$formData = $data["content"];
				$xml = $request["xml"];
				if(count($data["content"])>10){
					jsonError(FORM_OVERFLOW, "Your form is too large. 10 controls may be present in a form. You have ".count($data["content"]).".");
				}
				$dao->updateForm($title, $userId, $formData,$xml);
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
			case 'renameExpedition':
				$data = $request["expData"];
				$expId = $data["expId"];
				$newName = $data["name"];
				if(!validate_project_name($newName)){
					jsonError(TITLE_INVALID, "Your expedition's name is invalid.");
				}
				$dao->renameExpedition($expId, $newName);
				break;
			case 'getFindTimeStamps':
				$data = $request["projectData"];
				$projectId = $data["projId"];
				$lastUpdate = $dao->getLastFindTime($projectId);
				echo $lastUpdate;
				break;
			case 'updateFinds':
				$data = $request["projectData"];
				$projectId = $data["projId"];
				$projectTime = $data["projTime"];
				$newFinds = $dao->getFinds($projectId, $projectTime);
				if(count($newFinds)>=1){
					echo json_encode($newFinds);
				}
				break;
			case 'getTimeStamps':
				$data = $request["expData"];
				$expId = $data["expId"];
				if($data["expId"] != ""){
					$lastUpdate = $dao->getLastUpdate($expId);
					echo $lastUpdate;
				}
				break;
			case 'updateTracks':
				$data = $request["expData"];
				$expId = $data["expId"];
				$expTime = $data["expTime"];
				if($expId != ""){
					$newPoints = $dao-> getNewPoints($expId, $expTime);
					if(count($newPoints)>=1){
						echo json_encode($newPoints);
					}
				}
				break;
			default:
				header("Location: main");
		}
	
}

?>
