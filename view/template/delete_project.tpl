{include file="header.tpl" title="Delete Project" tab="projects"}
<div>

	<h2>Confirm Delete: <i>{$project.name}</i></h2>

		<p>
			Click the 'Confirm Delete' button below to delete your project.<br />
			Otherwise, click 'No Thanks' to return to your project list.<br />
			Keep in mind that this action cannot be undone.
		</p>
		<p>
			<form action="project.delete.do?id={$project.id}" method="post" style="display:inline">
				<input type="submit" name="del_submit" value="Confirm Delete">
				<input type="hidden" name="project_id" value="{$project.id}">
			</form>
			<form action="projects" method="get" style="display:inline">
				<input type="submit" name="del_submit" value="No Thanks">
			</form>
		</p>
</div>
{include file="footer.tpl"}