{include file="header.tpl" title="Share a project" tab="projects"}
<h2>Share a project</h2>
<div>
	{if $projects}
	<form action="project.share.do" method="post">
		<p>
			<label for="email">Username/Email: <span style="color: #666">(of the person to share the project with)</span> </label><br/>
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
	{else}
		<p>You are currently not owner of any projects. You can create a <a href="project.new">new project</a> to share.</p>
	{/if}
</div>
{include file="footer.tpl"}
