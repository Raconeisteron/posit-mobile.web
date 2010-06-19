{include file="header.tpl" title="Share a project" tab="projects"}
<h2>Share a project</h2>
<div>
	<form action="project.share.do" method="post">
		<p>
			<label for="description">Username/Email: <span style="color: #666">(of the person to share the project with)</span> </label><br/>
			<input type="text" name="email" />
		</p>
		<p>
			<label for="name">Project name:</label><br/>
				<select name="projectId">
					{foreach from=$projects item=project}
  						<option value="{$project.id}">{$project.name}</option>
					{/foreach}
				</select>
		</p>

		<input type="submit" value="Share project"/>	
	</form>
</div>
{include file="footer.tpl"}