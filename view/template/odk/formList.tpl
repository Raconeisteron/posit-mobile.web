<forms>
{foreach from=$forms item=form}
	<form url="{$smarty.const.SERVER_BASE_URI}/odk/formXml?formId={$form.id}">{$form.title}</form>
{/foreach}
</forms>