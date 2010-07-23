/**
 *  data-ui.js - data's sad little sibling
 *    Manages UI for dialogs involving saving/loading
 *    forms.
 */

var dataNS = odkmaker.namespace.load('odkmaker.data');

;(function($)
{
    dataNS.currentForm = null;
    dataNS.currentFormName = null;

    var openForm = function()
    {
        dataNS.currentFormName = $('.openDialog .formList li.selected').text();
        $.ajax({
            url: '../ajax/loadForm',
            dataType: 'json',
            type: 'POST',
            data: {formData: {title: dataNS.currentFormName}},
            success: function(response, status)
            {
                dataNS.currentForm = response;
                odkmaker.data.load(response);
                $('.openDialog').jqmHide();
          
            },
            error: function(request, status, error)
            {
                $('.openDialog .errorMessage')
                    .empty()
                    .append('<p>Could not open the form. Please try again in a moment.</p>')
                    .slideDown();
            }
        });
    };

    $(function()
    {
        // menu events
        $('.menu .newLink').click(function(event)
        {
            event.preventDefault();
            if (confirm('Are you sure? You will lose unsaved changes to the current form.'))
                odkmaker.application.newForm();
        });
        $('.menu .saveLink').click(function(event)
        {
            event.preventDefault();

            if (odkmaker.data.currentFormName === null)
            {
                $('.saveAsDialog').jqmShow();
                return;
            }

            $.ajax({
                url: '../ajax/updateForm',
                dataType: 'json',
                type: 'POST',
                data: {formData: {title: odkmaker.data.currentFormName, content: JSON.stringify(odkmaker.data.extract().controls)}},
                success: function(response, status)
                {
                	if(response!=null){
                		$.toast(response.errorMessage);
                    }else{
                    	$.toast("Your form has been saved.");
                    }
                },
                error: function(request, status, error)
                {
                	$.toast("Could not save the form. Please try again in a moment.");
                }
                });
        });

        // modal events
        $.live('.openDialog .formList li', 'click', function(event)
        {
            event.preventDefault();

            var $this = $(this);
            $this.siblings('li').removeClass('selected');
            $this.addClass('selected');
        });
        $('.openDialog .openLink').click(function(event)
        {
            event.preventDefault();
            openForm();
        });
        $.live('.openDialog .formList li', 'dblclick', function(event)
        {
            event.preventDefault();
            openForm();
        });

        $('.saveAsDialog .saveAsLink').click(function(event)
        {
            event.preventDefault();
            var title_form = $('.saveAsDialog #saveAs_name').val();
            if (title_form === '')
                return false;
            $('.saveAsDialog .errorMessage').slideUp();
            $.ajax({
                url: '../ajax/submitForm',
                dataType: 'json',
                type: 'POST',
                data: {formData: {title: title_form, content: JSON.stringify(odkmaker.data.extract().controls)}},
                success: function(response, status)
                {
                	if(response!=null){
                		$.toast(response.errorMessage);
                		$('.saveAsDialog').jqmHide();
                    }else{
                    	$.toast("Your form has been saved as "+title_form+".");
                    	$('.header h1').text(title_form);
                    	dataNS.currentFormName = title_form;
                    	$('.saveAsDialog').jqmHide();
                    }
                },
                error: function(request, status, error)
                {
                    $('.saveAsDialog .errorMessage')
                        .empty()
                        .append('<p>Could not save the form. Please try again in a moment.</p>')
                        .slideDown();
                }
                });
        });

        $('.exportDialog .downloadLink').click(function(event)
        {
            event.preventDefault();

            var $form = $('<form action="/download" method="post" target="downloadFrame" />');
            $form
                .append($('<input type="hidden" name="payload"/>').val(dataNS.serialize()))
                .append($('<input type="hidden" name="filename"/>').val($('h1').text() + '.xml'));
            $form.appendTo($('body'));
            $form.submit();
        });
    });
})(jQuery);
