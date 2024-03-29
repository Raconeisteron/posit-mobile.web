{include file="header.tpl" title=$project.name tab="projects"}
<h2>{$project.name}</h2>
<div class="project_searchForFinds">
<div id="secondary-menu">
<a href="projects">All Projects</a>
<a href="project.delete?id={$project.id}">Delete Project</a>
<a href="project.export?id={$project.id}">Export Project</a>
<a href="project.showMap?id={$project.id}">Map of Finds and Expeditions</a>
<a href="advanced.search?id={$project.id}">Advanced Search</a>
</div>
</div>
<form action="project.searchForFind" method="get">
	<input type="hidden" name="id" value="{$project.id}"/>
	<input type="text" name="searchTag"/>
	<input type="submit" value="Search For Finds"/>
</form>

<h2>Search results for: "{$searchFor}"</h2>
	{foreach from=$finds item=find}
	<div class="list-item">
		<div class="find_name"><a href="find.display?id={$find.guid}">{$find.name}</a></div>
		<div class="find_time">Found on: {$find.add_time|date_format:"%B %e, %Y %I:%M:%S"}</div>
		<div class="find_time">Updated on: {$find.modify_time|date_format:"%B %e, %Y %I:%M:%S"}</div>
		<div class="find_description">{$find.description}</div>
		<div class="find_id">{$find.guid}</div>
		<div class="find_img">
		{foreach from=$find.images item=imageid}
		<img src="displayPicture?id={$imageid}&size=thumb" height=40 width=40 />
		{/foreach}
		<p style="text-align:right"><a href="find.delete?id={$find.guid}">Delete Find</a></p>
		</div>
	<!-- enable this for psychedelic color<div class="list-item"> -->
	</div>
	{/foreach}
</div>
{include file="footer.tpl"}
