function rename_field(button){
	$("#renameDialog").css("display","inline");
	
	$("body").css("overflow","hidden");
	$("#renameDialog").dialog({resizable: false},{position: 'center'},{modal: true},{buttons:
		{
		"Confirm":function(){
			var dialog = this;
			if($(".serverError").length!=0){
				$(".serverError").fadeOut("slow",function(){
					$(".serverError").remove();
				});
				 setTimeout(function()
			    {
				renameConfirm(button, dialog);
			    },600);
			}
			else
				renameConfirm(button, dialog);
			},
		"Cancel":function(){
			$(this).dialog("close");	
			$("body").css("overflow","visible");
			$("#errorMessage").css("display","none");
			$(".serverError").remove();
			}
		}
	});
	
	return false;
}

function showOptions(label){
	$(".rename").slideUp();
	var div = $(label).parent();
	var renameOption = $(div).children("a");
	renameOption.slideDown();
	
}

function renameConfirm(button, dialog){
	var div = $(button).parent();
	var newName = $("#newName").attr("value");
	if(newName=='')
		return false;
	var expeditionId = $(div).children("[name*='id[]']").attr("value");
	 $.ajax({
         url: '../ajax/renameExpedition',
         dataType: 'json',
         type: 'POST',
         data: {expData: {expId: expeditionId, name: newName}},
         success: function(response, status)
         {
		 if(response==null){
        	$(div).children("label").text(newName);
        	$(dialog).dialog("close");
			$("body").css("overflow","visible");
		 }else{
			 $(dialog).prepend("<h5 class='serverError'style='color:red; display:none;'>"+response.errorMessage+"</h5>");
			 $(".serverError").fadeIn("slow");

		 }
        	
         },
         error: function(request, status, error)
         {
			 $("#errorMessage").fadeIn("slow");
         }
     });
 }

function fullScreen(){
	$("#map").removeClass('map-window')
	$("#map").attr("style","display: block; position: absolute; top: 0; left: 0; width: 100%; height: 100%; z-index: 500; margin: 0; padding: 0;	background: inherit;");
	initialize();
	
	$('body').css("overflow","hidden");
	window.scroll(0,0);	
	
	$("#fullscreenDialog").attr("style","overflow-y: scroll; overflow-x: none; display:inline; z-index: 1000");
	$("#fullscreenDialog").dialog({ draggable: true },{resizable: false},{position: 'right bottom'}, { height: 300}, { width: 310}
	);
	$("#fullscreenDialog").append($("[name='CheckAll']").clone());
	$("#fullscreenDialog").append($("[name='UnCheckAll']").clone());
	
	$("#fullscreenDialog").append($(".list-item").clone());
	$("#fullscreenDialog").children(".list-item").attr("class","dialog-item");
	
	$("#fullscreenDialog").find("[name='CheckAll']").click(function(){
		$("#fullscreenDialog").find("[type*='checkbox']").attr("checked",true);
		toggleAll();
	});

	$("#fullscreenDialog").find("[name='UnCheckAll']").click(function()	{
		$("#fullscreenDialog").find("[type*='checkbox']").attr("checked",false);
		toggleAll();
	});
	
	$("#fullscreenDialog").dialog("widget").hover(
		function(){
			$('#fullscreenDialog').dialog("widget").fadeTo('slow', 1);
		},
		function(){
			$('#fullscreenDialog').dialog("widget").fadeTo('slow', 0.3);
		}
	)
	
	$("#fullscreenDialog").find("[name='CheckAll']").trigger('click');
	$("#fullscreenDialog").dialog("widget").fadeTo('slow', 0.3)

}

function returnScreen(){

	$('#fullscreenDialog').dialog("widget").remove();
	$("#fullscreenDialog").children(":not(#minimize)").remove();
	$("#fullscreenDialog").attr("style","display:none");
	
	$('body').css("overflow","visible");
	$("#map").attr("style","");
	$("#map").addClass("map-window");
	initialize();
}

function updateTracks(ex) {
	if (!(expData[ex + "time"] == undefined)) {
		$.ajax( {
			url : "../ajax/updateTracks",
			data : {
				expData : {
					expId : expData[ex],
					expTime : expData[ex + "time"]
				}
			},
			type : "POST",
			dataType : "json",
			success : function(response) {
				if (response != null) {
					for (point in response) {
						expedition_points[ex].push(response[point]);
					}
				}
			},
			error : function() {
			}
		});
	}

}

	
	
