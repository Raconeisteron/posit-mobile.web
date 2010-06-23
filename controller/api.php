<?php

/**
 * the main apiController function that outputs json_encoded results
 * @param $path
 * @param $request
 * @param $files
 */
function apiController($path, $request, $files = null) {

	global $dao,$smarty;
	list($reqPath, $queryString) = explode('?', $path);
	$pathParts = explode('/', substr($reqPath,1));
	list($action) = $pathParts;
	
	if ($action != "addExpeditionPoint" && $action != "getDeviceByAuthKey") {
		$log = Log::getInstance();
		$log->log("$action");
		$log->log("$path, $request");
	}

	$authKey = $request["authKey"];

	if($action!="login" && $action!="registerUser" && $action != "registerDevice" && $action != "getPendingDeviceStatus" && !$authKey) {
		$response = array(
			"errorCode" => ERR_AUTHKEY_MISSING,
			"errorMessage" => "You must provide an authentication key with each request."
			);
			echo json_encode($response);
			die();
	}
	if ($action != "login" && $action != "registerUser"){
		$device = $dao->getDeviceByAuthKey($authKey);

		if($action != "registerDevice" && $action != "getPendingDeviceStatus" && !$device) {
			$response = errorResponseCode(ERR_AUTHKEY_INVALID, "Invalid authentication key.");
			echo json_encode($response);
			die();
		}
		$deviceUserId = $device["user_id"];
		$deviceIdentifier = $device["imei"];
	}




	switch($action) {
		case 'login':
			extract($request);
			if(!$email){
				jsonError(ERR_EMAIL_MISSING, "Email Address is required");
			}else {
				if (!validate_email_address($email)){
					jsonError(ERR_EMAIL_INVALID, "Email Address is invalid");
				}
			}
			if (!$password){
				jsonError(ERR_PASSWORD_MISSING, "Password is required");
			}
			if (!$imei){
				jsonError(ERR_IMEI_MISSING, "IMEI Code is required");
			}
		
			if ($login = $dao->checkLogin($email, $password)){
				$authKey = genAuthKey();
				$userId = $login["id"];
				
				if ($dao->registerDevicePending($userId, $authKey)){
					jsonMessage(AUTHN_OK, $authKey);
				}else {
					jsonError(ERR_SERVER, "Authentication Key cannot be generated");
				}
				 	
			}else {
				jsonError(AUTHN_FAILED,"Authentication failed. Please Check email address or password.");
			}
			break;
		case 'registerUser':
			extract($request);
			if(!$email){
				jsonError(ERR_EMAIL_MISSING, "Email Address is required");
			}else {
				if (!validate_email_address($email)){
					jsonError(ERR_EMAIL_INVALID, "Email Address is invalid");
				}
			}
			if(!$firstname){
				jsonError(ERR_FIRSTNAME_MISSING, "Firstname is required");
			}
			if(!$lastname){
				jsonError(ERR_LASTNAME_MISSING, "LastName is required");
			}
			if(strlen($password1) < 6){
				jsonError(ERR_PASSWORD1_INVALID, "Password must be 6 characters or longer");
			}
			if($password1 != $password2){
				jsonError(ERR_PASSWORD_UNMATCHED, "Passwords must match");
			}
			$newUser = array($email, $firstname, $lastname, $password1);
			$result = $dao->registerUser($newUser);
			if($result === REGISTRATION_EMAILEXISTS){
				jsonError(ERR_EMAIL_INVALID, "Email already exists");
			}
			$smarty->assign('link', SERVER_BASE_URI."/web/verifyEmail?email=$email");
			sendEmail($email, "email verification", $smarty->fetch("emails/new_user.tpl"));
			jsonMessage(AUTHN_OK, "Registration Successful");

			break;
		case 'getDeltaFindsIds':
			//			echo $dao->getDeltaFindsIds($deviceIdentifier);
			echo $dao->getDeltaFindsIds($authKey, $request["projectId"]);
			break;
		case 'recordSync':
			echo $dao->recordSync($deviceIdentifier);
			break;
		case 'registerDevice':
			$imei = $request["imei"];
			$name = null;
			if(strstr($authKey, "sb_"))
			$result = $dao->addSandboxDevice($authKey, $imei);
			else
			$result = $dao->confirmDevice($authKey, $imei, $name);
			echo json_encode($result);
			break;

		case 'addExpedition':
			echo $dao->addExpedition($request["projectId"]);
			break;

		case 'addExpeditionPoint':
			echo $request["expeditionId"].",";
			echo $dao->addExpeditionPoint($request["expeditionId"],$request["lat"],
			$request["lng"], $request["alt"], $request["swath"]);
			break;


		case 'getPendingDeviceStatus':
			$device = $dao->getDeviceByAuthKey($authKey);
			if($device["status"] == "ok")
			echo json_encode($device);
			else
			echo json_encode(false);
			break;
		case 'listOpenProjects':
			$result = $dao->getProjects(PROJECTS_OPEN);
			echo json_encode($result);
			break;
		case 'listMyProjects':
			$result = $dao->getUserProjects($deviceUserId);
			echo json_encode($result);
			break;
		case 'newProject':
			extract($request);
			if (!$name){
				jsonError(ERR_NAME_INVALID, "Project Name is invalid.");
			}
			$dao->newProject($name, $description, $deviceUserId);
			
			break;
		case 'listFinds':
			echo json_encode($dao->getFinds($request["project_id"]));
			break;
		case 'getFind':
			$result = $dao->getFind($request["guid"]);
			echo json_encode($result);
			break;
		case 'deleteFind':
			echo $dao->deleteFind($request["id"]);
			break;
		case 'deleteProject':
			$dao->deleteProject($request["projectId"]);
			break;
		case 'deleteAllFinds':
			$dao->deleteAllFinds($request["projectId"]);
			break;
		case 'createFind':
			echo $dao->createFind($authKey, $request["imei"], $request["guid"], $request["project_id"],
			$request["name"], $request["description"], $request["latitude"], $request["longitude"], $request["revision"]);
			break;
		case 'updateFind':
			echo $dao->updateFind($authKey, $request["imei"],$request["guid"],$request["project_id"],$request["name"], $request["description"], $request["revision"]);
			break;

		case 'attachPicture':
			$imagedata=base64_decode($request["data_full"]);
			$imagethumbdata=base64_decode($request["data_thumbnail"]);

			$result=$dao->addPictureToFind($request["imei"], $request["guid"], $request["identifier"], $request["project_id"],
			$request["mime_type"], $request["timestamp"], $imagedata, $imagethumbdata);
			echo json_encode($result);
			break;

		case 'attachVideo':
			$video_data = $files['file']['tmp_name'];
			$video_type = $request["mimeType"];
			$video_name = str_replace(' ','_',$files["file"]["name"]);
			move_uploaded_file($video_data, "uploads/$video_name");
			$result=$dao->addVideoToFind($request['id'], $request["findId"], $video_type, $video_name);
			return $result;
			break;
		case 'attachAudio':
			$audio_data = $files['file']['tmp_name'];
			$audio_type = $request["mimeType"];
			$audio_name = str_replace(' ','_',$files["file"]["name"]);
			move_uploaded_file($audio_data, "uploads/$audio_name");
			$result=$dao->addAudioClipToFind($request['id'], $request["findId"], $audio_type, $audio_name);
			return $result;
			break;
		case 'removePicture':
			$dao->deletePictureFromFind($request["id"]);
			break;
		case 'removeVideo':
			$dao->deleteVideoFromFind($request["id"]);
			break;
		case 'removeAudioClip':
			$dao->deleteAudioClipFromFind($request["id"]);
			break;
		case 'deleteAllPictures':
			$dao->deleteImages($request["findId"]);
			break;
		case 'deleteAllVideos':
			$dao->deleteVideos($request["findId"]);
			break;
		case 'deleteAllAudioClips':
			$dao->deleteAudioClips($request["findId"]);
			break;
		case 'getPicture':
			$picture=$dao->getPicture($request["id"]);
			$imageEncoded=base64_encode($picture["data_full"]);
			$imageThumbEncoded=base64_encode($picture["data_thumb"]);
			$pictureEncoded=$picture;
			if ($imageEncoded != "")
			$pictureEncoded["data_full"]=$imageEncoded;
			if ($imageThumbEncoded != "")
			$pictureEncoded["data_thumb"]=$imageThumbEncoded;
			if (count($pictureEncoded) > 0)
			echo json_encode($pictureEncoded);
			else echo "false";
			break;
		case 'getPicturesByFind' :
			$pictures = $dao->getPicturesByFind($request["guid"]);
			$result = array();
			foreach($pictures as $pic) {
				$imageEncoded=base64_encode($pic["data_full"]);
				$imageThumbEncoded=base64_encode($pic["data_thumb"]);
				$pictureEncoded=$pic;
				if ($imageEncoded != "")
				$pictureEncoded["data_full"]=$imageEncoded;
				if ($imageThumbEncoded != "")
				$pictureEncoded["data_thumb"]=$imageThumbEncoded;
				if (count($pictureEncoded) > 0)
				$result[] = $pictureEncoded;
			}
			if(count($result) > 0)
			echo json_encode($result);
			else echo "false";
			break;
		case 'getVideo':
			$video=$dao->getVideo($request["id"]);
			$video_name=$video["data_path"];
			$video_path="uploads/$video_name";
			$fp_v = fopen($video_path, 'r');
			$video_data = fread($fp_v, filesize($video_path));
			$videoEncoded=base64_encode($video_data);
			$clipEncoded = $video;
			$clipEncoded["data_full"]=$videoEncoded;
			echo json_encode($clipEncoded);
			break;
		case 'getAudio':
			$audio=$dao->getAudioClip($request["id"]);
			$audio_name=$audio["data_path"];
			$audio_path="uploads/$audio_name";
			$fp_v = fopen($audio_path, 'r');
			$audio_data = fread($fp_v, filesize($audio_path));
			$audioEncoded=base64_encode($audio_data);
			$clipEncoded=$audio;
			$clipEncoded["data_full"]=$audioEncoded;
			echo json_encode($clipEncoded);
			break;
		case 'searchFinds':
			$search_value=$request['search_value'];
			$project_id=$request['project_id'];
			$result=$dao->searchFinds($search_value, $project_id);
			echo json_encode($result);
			break;
		case 'execCommand':
			$command=$request['command'];
			echo $dao->execCommand($command);
			break;

		default:
			break;
	}
}

?>
