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
		default:
			break;
	}
	
}
?>