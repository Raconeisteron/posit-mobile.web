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
	header("Content-Type: text/xml; charset=iso-8859-1");
	switch($action) {
		case 'formList':
			$forms = $dao->listAllForms();
			$smarty->assign("forms", $forms);
			
			$smarty->display('odk/formList.tpl');
			
			break;
		default:
			break;
	}
	
}
?>