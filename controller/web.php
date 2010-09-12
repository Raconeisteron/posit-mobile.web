<?php

function webController($path, $request) {
	global $smarty, $dao, $error;
	list($reqPath, $queryString) = explode('?', $path);
	$pathParts = explode('/', substr($reqPath,1));
	list($action) = $pathParts;

//	Log::getInstance()->log("Reached server");
	Log::getInstance()->log("$path , $request");

	session_start();
	$authnStatus = checkAuthn(); 
	
	if(isLoggedIn()) {
		$smarty->assign("loggedIn", true);
		$smarty->assign("loginEmail", $_SESSION["loginEmail"]);
	} else {
		$smarty->assign("loggedIn", false);
	}
	
	if(checkAuthz($action) && $authnStatus != AUTHN_FAILED) {
		// user is authorized
	
	$loginId = $_SESSION["loginId"];
	if($loginId) {
		$loginUser = $dao->getUser($loginId);
		
		if($loginUser["privileges"] == "admin")
			$loginHasAdmin = true;
		else
			$loginHasAdmin = false;
	} else
		$loginhasAdmin = false;
		
		$smarty->assign("loginHasAdmin", $loginHasAdmin);
		
		switch($action) {
			case 'formbuilder.iframe':
				$smarty->display('build.tpl');
				break;
			case 'formbuilder':
				$smarty->display('formbuilder.tpl');				
				break;
			case 'main':
				$smarty->display('main.tpl');
				break;
			case 'build':
				$smarty->display('build.tpl');
				break;
			case '404':
				$smarty->display('404.tpl');
				break;
			case 'maps':
				$projects = $dao->getProjects();
				$smarty->assign("projects", $projects);
				$smarty->display('maps.tpl');
				break;
			case 'login':
				$smarty->display('header.tpl');
				$smarty->display('login.tpl');
				$smarty->display('footer.tpl');
				break;
			case 'login.do':
				if($_POST["loginDestination"])
					$destination = "../web". $_POST["loginDestination"];
				else
					$destination = "main";
				header("Location: $destination");
				break;
			case 'logout':
				session_destroy();
				header("Location: main");
				break;
			case 'register':
				$smarty->display('register.tpl');
				break;
			case 'register.do':
				extract($request);
				if(!$email)
					errorMessage("Email address is required.");
				if(!$firstName)
					errorMessage("First name is required.");
				if(!$lastName)
					errorMessage("Last name is required.");
				if(strlen($pass1) < 6)
					errorMessage("Password must be 6 characters or longer.");
				if($pass1 != $pass2)
					errorMessage("Password and password confirmation do not match.");
				
				$newUser = array($email, $firstName, $lastName, $pass1);
				$result = $dao->registerUser($newUser);

				if($result === REGISTRATION_EMAILEXISTS)
					errorMessage("That email address already exists.");
				$_SESSION["loggedIn"] = true;
				$_SESSION["loginId"] = $result[0];
				$_SESSION["loginEmail"] = $email;
				header("Location: main");
				break;
			case 'admin.logs':
				//var_dump($request);
				$pageNum=$request["page"];
				if(!$request["page"])
					$pageNum=1;
				$numPages=$dao->numLogPages();
				$numArray = range(1,$numPages);
				$logs=$dao->getLogs($pageNum);
				$smarty->assign("numPages",$numPages);
				$smarty->assign("pageNum",$pageNum);
				$smarty->assign("numArray",$numArray);
				$smarty->assign("logs",$logs);
				$smarty->display("logs.tpl");
				break;
			case 'projects':
				$loginId = $_SESSION["loginId"];
				$projects = $dao->getUserProjects($loginId);
				$smarty->assign("projects", $projects);
				$smarty->display("projects.tpl");
				break;
			case 'expeditions':
				$projectId = $request["project_id"];
				$expeditions = $dao->getExpeditions($projectId);
				$smarty->assign("expeditions", $expeditions);
				$smarty->display("expeditions.tpl");
				break;
			case 'expedition.tracker':
				$expeditionId = $request["id"];
				$expeditionPoints = $dao->getExpeditionPoints($expeditionId);
				$smarty->assign("expeditionPoints", $expeditionPoints);
				$smarty->display("expedition_tracker.tpl");
				break;
			case 'project.new':
				$smarty->assign("error", $_SESSION["error"]);
				$_SESSION["error"] = "";
				$smarty->display("new_project.tpl");
				break;
			case 'project.new.do':
				$name = $request["name"];
				$description = $request["description"];
				$loginId = $_SESSION["loginId"];
				if ($name == ""){
					$_SESSION["error"] = "Project name must be entered.";
					header("Location: project.new");
					break;
				}else {
					if (!validate_project_name($name)){
						$_SESSION["error"] = "project name invalid.";
						header("Location: project.new");
						break;
					}
				}
				if ($description != ""){
					$description = 
					$description = strip_tags($description , "<b>");
				}
				$dao->newProject($name, $description, $loginId);
				header("Location: projects");
				break;
			case 'project.share':
				$loginId = $_SESSION["loginId"];
				$projects = $dao->getOwnerProjects($loginId);
				$smarty->assign("error", $_SESSION["error"]);
				$_SESSION["error"] = "";
				$smarty->assign("projects", $projects);
				$smarty->display("share_project.tpl");
				break;
			case 'project.share.do':
				$loginId = $_SESSION["loginId"];
				if (!$request["email"]){
					$_SESSION["error"] = "email required";
					header("Location: project.share");
					break;
				}else {
					if ($request["email"] == ""){
						$_SESSION["error"] = "email required";
						header("Location: project.share");
						break;
					}
				}
				if ($userId = $dao->getUserId($request["email"])){
					$error = "Username doesn't exist";
					header("Location: project.share");
				}
				$projectId = $request["projectId"];

				//print_r("projectid: ".$projectId."userId:".$userId);
				$projects = $dao->shareProject($loginId, $userId, $projectId);
				header("Location: projects");
				break;
			case 'project.delete':
				$project_id = $request["id"];
				$project = $dao->getProject($project_id);
				$smarty->assign("project",$project);
				$smarty->display("delete_project.tpl");
				break;
			case 'find.delete':
				$find_id = $request["id"];
				$find = $dao->getFind($find_id);
				$smarty->assign("find",$find);
				$smarty->display("delete_find.tpl");
				break;
			case 'project.delete.do':
				$project_id = $request["id"];
				$dao->deleteProject($project_id);
				header("Location: projects");
				break;
			case 'find.delete.do':
				$find_id = $request["id"];
				$find = $dao->getFind($find_id);
				$location = "project.display?id=".$find["project_id"];
				$dao->deleteFind($find_id);
				header("Location: ".$location);
				//THIS LINE WILL PROBABLY NEED TO BE CHNANGED TO SPECIFY THE PROJECT ID...
			case 'project.showMap':
				$project_id = $request["id"];
				$project = $dao->getProject($project_id);
				$smarty->assign("project",$project);
				$finds = $dao->getFinds($project_id);
				$expeditions = $dao->getExpeditions($project_id);
				$expedition_points = array();
				$expeditionKeys = array();
			
				//print_r($expeditions);
				foreach($expeditions as $k=>$expedition){
					$temp_points = $dao->getExpeditionPoints($expedition['id']);
					if (count($temp_points) > 1) {
						
						$expedition_points[$k] = $temp_points;
						$expeditionKeys[$k] = $expedition['id']; 
					}
					else{
						unset($expeditions[$k]);

					}
					/*	echo "ACCEPTING expedition {$expedition['id']}:\n";
						print_r($temp_points);
						echo "\n\n"; 
					} else {
						
						echo "REJECTING expedition {$expedition['id']}:\n";
						print_r($temp_points);
						echo "\n\n"; */ 
					
				}
		//		print_r($expeditions);
				if(count($expeditions)==0 && count($finds)!= 0){

					$smarty->assign("expCheck", 0);
					$smarty->assign("findCheck", 1);
					$smarty->assign("finds", addslashes(json_encode($finds)));
					$smarty->assign("expeds", json_encode($expeditionKeys));
					$smarty->assign("expeditions", $expeditions);
					$smarty->assign("expedition_points",json_encode($expedition_points));
					$smarty->assign("expedition_points_decode",$expedition_points);
					$extremes = $dao->getFindExtremes($project_id);
					$smarty->assign('extremes',$extremes);
					$geocenter = $dao->getGeocenter($extremes);
					$smarty->assign('geocenter',$geocenter);
					$colors = array("ff0000","ff8800","ffff00","99ff00","00ff00","337766","0000ff","9955ff","6600bb","ff0088");
					$smarty->assign('colors',json_encode($colors));
					$smarty->assign('colors_decode',$colors);
					$smarty->display("project_dualdisplay_test.tpl");					
				}
				if(count($finds)==0 && count($expeditions)!= 0){
					$smarty->assign("expCheck", 1);
					$smarty->assign("findCheck", 0);
					$smarty->assign("finds", addslashes(json_encode($finds)));
					$smarty->assign("expeds", json_encode($expeditionKeys));
					$smarty->assign("expeditions", $expeditions);
					$smarty->assign("expedition_points",json_encode($expedition_points));
					$smarty->assign("expedition_points_decode",$expedition_points);
					$extremes = $dao->getExpExtremes($expeditions);
					$smarty->assign('extremes',$extremes);
					$geocenter = $dao->getGeocenter($extremes);
					$smarty->assign('geocenter',$geocenter);
					$colors = array("ff0000","ff8800","ffff00","99ff00","00ff00","337766","0000ff","9955ff","6600bb","ff0088");
					$smarty->assign('colors',json_encode($colors));
					$smarty->assign('colors_decode',$colors);
					$smarty->display("project_dualdisplay_test.tpl");		
				}
				if(count($finds)== 0 && count($expeditions)== 0){
					$smarty->display("empty_project.tpl");
				}
				if(count($finds)!= 0 && count($expeditions)!= 0){
					$smarty->assign("expCheck", 1);
					$smarty->assign("findCheck", 1);
					$smarty->assign("finds", addslashes(json_encode($finds)));
					$smarty->assign("expeds", json_encode($expeditionKeys));
					$smarty->assign("expeditions", $expeditions);
					$smarty->assign("expedition_points",json_encode($expedition_points));
					$smarty->assign("expedition_points_decode",$expedition_points);
					$find_extremes = $dao->getFindExtremes($project_id);
					$exp_extremes = $dao->getExpExtremes($expeditions);
					$extremes = $dao->getDualExtremes($exp_extremes,$find_extremes);
					$smarty->assign('extremes',$extremes);
					$geocenter = $dao->getGeocenter($extremes);
					$smarty->assign('geocenter',$geocenter);
					$colors = array("ff0000","ff8800","ffff00","99ff00","00ff00","337766","0000ff","9955ff","6600bb","ff0088");
					$smarty->assign('colors',json_encode($colors));
					$smarty->assign('colors_decode',$colors);
					$smarty->display("project_dualdisplay_test.tpl");
				}
				break;
			case 'project.display':
				list($queryType, $queryValue) = explode("=", $queryString);
				$id = $queryValue;
				$project = $dao->getProject($id);
				$smarty->assign("project", $project);
				$finds = $dao->getFinds($id);
				$smarty->assign("finds", $finds);
				$smarty->display("project_display.tpl");
				break;
			case 'find.display':
				list($queryType, $queryValue) = explode("=", $queryString);
				$id = $queryValue;
				$find = $dao->getFind($id);
				
//				$find = $dao->getFind($find["barcode_id"]);
				$project_id = $find["project_id"];
				$project = $dao->getProject($project_id);;
				
				
				$smarty->assign("images",$find["images"]);
//				$smarty->assign("videos",$find["videos"]);
//				$smarty->assign("audioClips",$find["audioClips"]);
				$smarty->assign("project", $project);
				$smarty->assign("find", $find);
				$smarty->display("find_display.tpl");
				break;
			case 'project.export':
				$project_id = $request["id"];
				$project_name = $dao->formatProjectName($project_id);
				$filename = $project_name . ".csv";
				$writer = $dao->exportProject($project_id);
				header('Content-Type: text/csv');
				header("Content-Disposition: attachment; filename=$filename");
				echo $writer;
				break;
		
			case 'settings':
				$userId = $_SESSION["loginId"];
				$devices = $dao->getDevicesByUser($userId);
				
				$smarty->assign("devices", $devices);
				$smarty->display("settings/settings.tpl");
				break;
			case 'settings.registerDevice':
				$authKey = genAuthKey();
				$userId = $_SESSION["loginId"];
				$result = $dao->registerDevicePending($userId, $authKey);
				
				$server = SERVER_BASE_URI;

				$email = $_SESSION["loginEmail"];
				
				$data = array(
					"server" => $server,
					"authKey" => $authKey
				);
				
				$smarty->assign("baseUrl", $server);
				$smarty->assign("authKey", $authKey);
				$smarty->assign("data", urlencode(json_encode($data)));
				$smarty->display("settings/registerDevice.tpl");
				break;
			case 'settings.registerDevice.do':
				$imei = $request["imei"];
				$deviceName = $request["deviceName"];
				
				$result = $dao->changeDeviceNickname($imei, $deviceName);
				
				header("Location: settings");
				break;
			
			case 'removeDevice.do': 
				$imei = $request["imei"];
				$dao->removeDevice($imei);
				header("Location: settings");
				break;
			
			case 'purge':
				echo "Purging pending device registrations...";
				$dao->purgePendingDevices();
				break;
			
			case 'displayPicture':
				$id=$request["id"];
				$image=$dao->getPicture($id);
				$size=$request["size"];
				if ($size == "thumb"){
					$data=$image["data_thumb"];
				}
				else{
					$data=$image["data_full"];
				}
				$mimeType=$image["mime_type"];
				header("Content-Type: $mimeType");
				echo $data;
				break;
	
			case 'displayVideo':
				$id=$request["id"];
				$video=$dao->getVideo($id);
				$video_name=$video["data_path"];
				$video_path="uploads/$video_name";
				$fp_v = fopen($video_path, 'r');
				$video_data = fread($fp_v, filesize($video_path));
				header("Content-type: video/3gp");
				echo $video_data;
				break;
				
			case 'displayAudio':
				$id=$request["id"];
				$audio=$dao->getAudio($id);
				$audio_name=$audio["data_path"];
				$audio_path="uploads/$audio_name";
				$fp_v = fopen($audio_path, 'r');
				$audio_data = fread($fp_v, filesize($audio_path));
				header("Content-type: audio/3gp");
				print $audio_data;
				break;
				
			case 'admin':
				$smarty->display("admin/admin.tpl");
				break;	
			
			case 'qrcode':
				$oldwd = getcwd();
				chdir("3rd");
				require_once("qr_img.php");
				chdir($oldwd);
				break;

			case 'customPosit.list':
				$project_id = $request["project_id"];
				//$instances = $dao->getInstancesForProject($project_id);
				//$smarty->assign("instances", $instances);
				$smarty->assign("project_id", $project_id);
				$smarty->display("custom_posit_list.tpl");
				break;

			case 'customPosit.download':
				$project_id=$request["project_id"];
				//hack to get just project_id because php doesn't support multiple constructors.. 
				$data = array(null, $project_id, null, null, null);
				$posit = new CustomPosit($data);
				$posit->download();
				break;
			case 'customPosit':
				$userId = $_SESSION["loginId"];
				
				$devices = $dao->getDevicesByUser($userId);
				$smarty->assign("devices", $devices);
				$project_id=$request["project_id"];
				$smarty->assign("project_id", $project_id);
				$smarty->display("custom_posit.tpl");
				break;
				
			case 'customPosit.create.do':
				
				$name = $request["name"];
				$project_id= $request["project_id"];
				$description = $request["description"];
				$sync_on = $request["sync_on"];
				$device_id = $request["device_id"];
				echo $project_id;
				$data = array($name, $project_id, $description, $sync_on, $device_id);
				
				if ($name==null || $project_id ==null){
					$smarty->assign("name", $name);
					$smarty->assign("project_id",$project_id);
					$smarty->assign("description",$description);
					$smarty->assign("device_id",$device_id);
					$smarty->display("custom_posit.tpl");
				}
				$posit = new CustomPosit($data);
				$posit->build();
				break;
			default:
				header("Location: main");
		}
	
	} else if($authnStatus == AUTHN_OK) {
		// user is authenticated but not authorized
	} else if($authnStatus == AUTHN_FAILED){
		// user failed authentication'
		$smarty->display("header.tpl");
		$smarty->assign("errMsg", "Login failed.");
		$smarty->display("login.tpl");
		$smarty->display("footer.tpl");
	} else {
		// user is not authenticated
		$smarty->display("header.tpl");
		$smarty->assign("destination", $path);
		$smarty->display("login.tpl");
		$smarty->display("footer.tpl");
	}
}

?>
