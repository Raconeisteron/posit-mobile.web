{include file="header.tpl" title="Logs" tab="admin"}
<h2>Logs</h2>
<div class="log-list">
	{if $logs}
		<table border="1">
			<tr><td>id</td><td>Time</td><td>Type</td><td>Tag</td><td>Description</td></tr>
		{foreach from=$logs item=log}
		<tr>
			<td>{$log.id}</td>
			<td>{$log.time}</td>
			<td align="center">{$log.type}</td>
			<td>{$log.tag}</td>
			<td>{$log.message}</td>
		</tr>
		{/foreach}
		</table>
		<br>
		{if $pageNum>1}
		<a href="admin.logs?page={$pageNum-1}"><</a>
		{/if}
		{foreach from=$numArray item=count}
			{if $pageNum==$count}
				<b>{$pageNum}</b>
			{else}
				<a href="admin.logs?page={$count}">{$count}</a>
			{/if}
		{/foreach}
		{if $numPages>$pageNum}
		<a href="admin.logs?page={$pageNum+1}">></a>
		{/if}
	{else}
		<em>There are no logs on this server yet.</em>
	{/if}
</div>