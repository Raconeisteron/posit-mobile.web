{include file="header.tpl" title="Delete Project" tab="projects"}
<div>
	<h2>Confirm Delete: <i>{$find.name}</i></h2>
	
		<p>Click the 'Confirm Delete' button below to delete your find.</p>
		<p>Otherwise, click 'No Thanks' to return to your project.</p>
		<p>Keep in mind that this action cannot be undone.</p>
		
		<p>
			<form action="find.delete.do?id={$find.guid}" method="post" style="display:inline">
				<input type="submit" name="del_submit" value="Confirm Delete">
				<input type="hidden" name="find_id" value={$find.guid}>
			</form>
			<form action="find.display?id={$find.guid}" method="post" style="display:inline">
				<input type="submit" name="del_submit" value="No Thanks">
				<input type="hidden" name="find_id" value={$find.guid}>
			</form>
		</p>

<div>
{include file="footer.tpl"}