{include file="header.tpl" title=$project.name tab="projects"}
<h2>{$project.name}</h2>
<div class="project_finds">
<div id="secondary-menu">
<a href="projects">All Projects</a>
<a href="project.delete?id={$project.id}">Delete Project</a>
<a href="project.export?id={$project.id}">Export Project</a>
<a href="project.showMap?id={$project.id}">Map of Finds and Expeditions</a>
<a href="advanced.search?id={$project.id}">Advanced Search</a>
</div>
</div>
<h2>Advanced Search</h2>
<form action="advanced.searchForFind" method="get">
	<input type="hidden" name="id" value="{$project.id}"/>
	Find Name&nbsp;&nbsp;<input type="text" name="project"/>
	<br/>
	Description&nbsp;<input type="text" name="description"/>
	<br/>
	<input type="submit" value="Search For Finds"/>
</form>
</div>
{include file="footer.tpl"}
