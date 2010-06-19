{include file="header.tpl" title="Projects Page" tab="projects"}
<h2>Your Projects</h2>
<p>
<div id="secondary-menu">
	<a href="project.new">New project</a> 
	<a href="project.share">Share project</a>
</div>

<div class="project-list">
	{if $projects}
		{foreach from=$projects item=project}
		<div class="list-item">
			<a href="project.display?id={$project.id}" class="project-name">{$project.name}</a>
			<span class="project-role">{$project.role}</span>
			<p class="project-description">{$project.description}</p>
		</div>
		{/foreach}
	{else}
		<em>There are no projects on this server yet.</em>
	{/if}
</div>
{include file="footer.tpl"}
