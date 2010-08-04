{include file="header.tpl" title="Expeditions Page" tab="projects"}
<h2>{$project.name}</h2>
<h3>All Expeditions</h3>
<script type="text/javascript" src="../res/js/expeditions.js"></script>
<script type="text/javascript" src="../res/js/jquery-1.4.2.min"></script>
<script type="text/javascript" src="../res/js/jquery-ui-1.8.2.custom.min.js"></script>
<link type="text/css" rel="stylesheet" media="all" href="../res/style/jquery-ui-1.8.2.custom.css" /> 
<script type="text/javascript">
	{literal}
	function checkAll(field)
	{
	for (i = 0; i < field.length; i++)
		field[i].checked = true ;
	}
	function uncheckAll(field)
	{
	for (i = 0; i < field.length; i++)
		field[i].checked = false ;
	}
	{/literal}
</script>
<div id="renameDialog" style="display:none;" title="Rename Your Expedition">
	<h5 id="errorMessage" style="color:red; display:none;" >Error connecting to server. Please try again later.</h5>
	<h5>Enter a new name for your expedition</h5>
	<input type="text" id="newName" style="width:275">
</div>

<div class="expedition_list">
	{if $expeditions}
	<form name="expeditions" action="expedition.tracker">
	{foreach from=$expeditions item=expedition}
	<div class="list-item">
		<input type="checkbox" name="id[]" value="{$expedition.id}" /><a href="expedition.tracker?id[]={$expedition.id}"> {$expedition.name} {$expedition.id}</a> 
		<p class="description">{$expedition.description}</p>
		<input type="button" class="rename" value="Rename" onclick="rename_field(this);">
	</div>
	{/foreach}
	<input type="button" name="CheckAll" value="Check All"
		onClick="checkAll(expeditions)">
	<input type="button" name="UnCheckAll" value="Uncheck All"
		onClick="uncheckAll(expeditions)">
	<input type="submit" value="View Selected" />
	</form>
	{else}
		<em>There are no expeditions on this project yet.</em>
	{/if}
</div>
{include file="footer.tpl"} 