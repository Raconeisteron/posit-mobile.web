<?php
 /**
 * the main apiController function that outputs json_encoded results
 * @param $path
 * @param $request
 * @param $files
 */
function odkController($path, $request, $files = null) {

	global $dao,$smarty;
	list($reqPath, $queryString) = explode('?', $path);
	$pathParts = explode('/', substr($reqPath,1));
	list($action) = $pathParts;
	
	switch($action) {
		case 'formList':
			$forms = $dao->listAllForms();
			header("Content-Type: text/xml; charset=iso-8859-1");
			$smarty->assign("forms", $forms);
			$smarty->display('odk/formList.tpl');
			break;
		case 'formXml':
			header("Content-Type: text/xml; charset=iso-8859-1");
			$id = $request["formId"];
			echo $dao->loadFormXml($id);
		case 'submission':
//			$fh = fopen("submission", "w");
//			ob_start();
//			
//			var_dump($files);
//			var_dump($files["xml_submission_file"]);
//			
//			
//			
//			fwrite($fh,ob_get_contents());
//			ob_end_clean();
//			fclose($fh);
			$file_name = $files["xml_submission_file"]["name"];
			$target_path = "uploads/".$file_name;
			
			if (move_uploaded_file($files["xml_submission_file"]["tmp_name"], $target_path)){
//				header("HTTP/1.1 200 OK");
				header ("Location: ". SERVER_BASE_URI."/odk",true, 201);
				echo "upload successful ". $file_name;
				
			}
			else{ 
				echo "upload failed ". $file_name;
			}
						
			break;
		default:
			break;
	}
	
}
?>