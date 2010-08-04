{include file="header.tpl" title=$project.name tab="project"}

{literal}
<script type="text/javascript" src="../res/js/jquery-1.4.2.min"></script>
<script type="text/javascript" src="../res/js/jquery-ui-1.8.2.custom.min.js"></script>
<link type="text/css" rel="stylesheet" media="all" href="../res/style/jquery-ui-1.8.2.custom.css" /> 
<script type="text/javascript" src="../res/js/expeditions.js"></script>
<style type="text/css">
	
	.expedition-list {
		float:right;
		width:20%;
		padding:0;
		margin:0;
	}																																																
	
	.map-window {
		float:left;
		width:78%;
		height:100%;
		padding:0;
		margin:0;
	}
	
	.list-item {
		border:none;
		padding:0;
	}
	
	.legend-color {
		width:10px;
	}
		
</style>

<script language="JavaScript">
		function sum(a) {
			var sum = 0;
			for(var i in a)
				sum += a[i];
			return sum;
		}
		function avg(a){
			if (a.length > 0) 
				return sum(a) / a.length;
			else 
				return 0;
		}
		function min(a) {
			var min = null;
			for(var i in a) {
				if(min == null || a[i] < min)
					min = a[i];
			}
			return min;
		}
		function max(a) {
			var max = null;
			for(var i in a) {
				if(max == null || a[i] > max)
					max = a[i];
			}
			return max;
		}
		function checkAll(field) {
			for (i = 0; i < field.length; i++)
				field[i].checked = true ;
		}
		function uncheckAll(field) {
			for (i = 0; i < field.length; i++)
				field[i].checked = false ;
		}
		<!-- calculates distance in miles between two geostamps -->
		function distanceInMiles(lat1, lng1, lat2, lng2) {
			return (3958.75 * Math.acos(Math.sin(lat1 / 57.2958) * Math.sin(lat2 / 57.2958) + Math.cos(lat1 / 57.2958) * Math.cos(lat2 / 57.2958) * Math.cos(lng2 / 57.2958 - lng1 / 57.2958)));
		}
		<!-- calculates the zoom level of the map utility based on the span of the points-->
		function getZoomLevel(pointSpan) {
			if(pointSpan < 0.2) zoomLevel = 16;
		     else	if(pointSpan < 0.5) zoomLevel = 15;
		     else	if(pointSpan <   1) zoomLevel = 14;
		     else	if(pointSpan <   2) zoomLevel = 13;
		     else	if(pointSpan <   3) zoomLevel = 12;
		     else	if(pointSpan <   7) zoomLevel = 11;
		     else	if(pointSpan <  15) zoomLevel = 10;
		     else						zoomLevel =  9;
			 zoomLevel += 1;
		     return zoomLevel; 
		}

		function toggleExpedition(k) {
			if($(".dialog-item").length != 0){
				var chkBox = $(".dialog-item #check_"+k);
				if(chkBox.attr('checked'))				
					expeditions[k].show();
				else
					expeditions[k].hide();
				return;
			}
			check_box = document.getElementById('check_' + k);
			if (check_box.checked){
				expeditions[k].show();
			}
			else {
				expeditions[k].hide();
			}
		}
		function toggleAll() {
			for (i in expeditions) {
				toggleExpedition(i);
			}
		}
		var map;
		var expeditions = [];
		var expedition_points;
		var finds;
		var colors;
		var markers = [];
		var lats = [];
		var lngs = [];
		var expColor = new Array();
			{/literal}
				if(expedition_points==undefined)
					expedition_points = {$expedition_points};
			{literal}
		google.load("maps", "2.x");

		function initialize() {
			map = new google.maps.Map2(document.getElementById("map"));
			map.checkResize();
			GEvent.addListener(map, "tilesloaded", function() {
				initializeTimeStamps(0);
				getFindTimeStamps();
				setTimeout(function(){beginUpdate()}, 10000);
    			});
			{/literal}
				var dist1 = distanceInMiles({$extremes.north}, {$extremes.east}, {$extremes.north}, {$extremes.west});
				var dist2 = distanceInMiles({$extremes.north}, {$extremes.east}, {$extremes.south}, {$extremes.east});
				var dist_array = [dist1,dist2];
				var pointSpan = max(dist_array);
				var zoomLevel = getZoomLevel(pointSpan);
				map.setCenter(new GLatLng({$geocenter.lat},{$geocenter.long}), zoomLevel);
				var location_data = eval('{$location_data}');
				finds = eval('{$finds}');
			{literal}
			// THIS IS WHERE THE EXPEDITIONS WILL GO (comment block l.126)

			
			var redIcon = new GIcon(G_DEFAULT_ICON);
				redIcon.image = "http://posit.hfoss.org/demo/res/image/redmark.png";
				redIcon.iconSize = new GSize(14, 22);
				redIcon.iconAnchor = new GPoint(7, 21);
				redIcon.shadow = "http://posit.hfoss.org/demo/res/image/redshadow.png";
				redIcon.shadowSize = new GSize(39, 31);
		
		
			for(var i in finds) {
				var point = new GLatLng(finds[i]['latitude'], finds[i]['longitude']);
				var marker = new GMarker(point);
				marker.findIndex = i;
				GEvent.addListener(marker, "click", function() {
					this.openInfoWindowHtml("<b>"+ finds[this.findIndex]['name'] + "</b><p>" + finds[this.findIndex]['description'] + '</p><p><a target="find" href="find.display?id=' + finds[this.findIndex]['guid'] + '">more info</a></p>');
				});
				
				    $( ".selector" ).dialog({ closeText: 'hide' });


				markers.push(marker);
				lats.push(point.lat());
				lngs.push(point.lng());
				
				map.addOverlay(marker);
				
			
			
			}
			
			{/literal}
			colors = {$colors};
			{literal}
			
			var color_index = 0;
			for (i in expedition_points) {
				var temp_array = [];
				for (j in expedition_points[i]) {
					exp_point = expedition_points[i][j];
					temp_point = new GLatLng(exp_point['latitude'],exp_point['longitude']);
					temp_array.push(temp_point);
				}
				var polyline = new GPolyline(temp_array, colors[color_index%(colors.length)], 10);
				map.addOverlay(polyline);
				expeditions[i] = (polyline);
				expColor[i] = color_index;
				color_index = color_index + 1;

			}
				
			var mapControl = new GMapTypeControl();
			map.addControl(mapControl);
			map.addControl(new GLargeMapControl());
			
		}			
		// var color_length = count(colors);
		
		google.setOnLoadCallback(initialize);
		
	{/literal}
	var expData = {$expeds};
	var projectId = {$project.id};
	{literal}
	
	function reinitializeOverlay(){
			map.clearOverlays();
			var color_index = 0;
			for (i in expedition_points) {
				var temp_array = [];
				for (j in expedition_points[i]) {
					exp_point = expedition_points[i][j];
					temp_point = new GLatLng(exp_point['latitude'],exp_point['longitude']);
					temp_array.push(temp_point);
				}
				var polyline = new GPolyline(temp_array, colors[color_index%(colors.length)], 10);
				map.addOverlay(polyline);
				expeditions[i] = (polyline);
				expColor[i] = color_index;
				color_index = color_index + 1;

			}
	
			for(var i in finds) {
				var point = new GLatLng(finds[i]['latitude'], finds[i]['longitude']);
				var marker = new GMarker(point);
				marker.findIndex = i;
				GEvent.addListener(marker, "click", function() {
					this.openInfoWindowHtml("<b>"+ finds[this.findIndex]['name'] + "</b><p>" + finds[this.findIndex]['description'] + '</p><p><a target="find" href="find.display?id=' + finds[this.findIndex]['guid'] + '">more info</a></p>');
				});
				
				$( ".selector" ).dialog({ closeText: 'hide' });


				markers.push(marker);
				lats.push(point.lat());
				lngs.push(point.lng());
				
				map.addOverlay(marker);
				
			
			}
	}
	
	function reinitializeOverlayItem(ex){
		map.removeOverlay(expeditions[ex]);
		var temp_array = [];
		for (j in expedition_points[ex]) {
			exp_point = expedition_points[ex][j];
			temp_point = new GLatLng(exp_point['latitude'],exp_point['longitude']);
			temp_array.push(temp_point);
			}
		var polyline = new GPolyline(temp_array, colors[expColor[ex]%(colors.length)], 10);
		map.addOverlay(polyline);
		expeditions[ex] = (polyline);
	}
	
	function getNewPoints(ex){
		updateTracks(ex);
		setTimeout("reinitializeOverlayItem("+ex+")", 1000);
		getTimeStamp(ex);
	}
	
	var indices = new Array();
	var lastFindTime = null;
	var counter = 0;
	var initUpdate = new Array();	
	for(ex in expData){
		indices[counter] = ex;	
		counter++;
	}
	
	function initializeTimeStamps(index){
		if(index<indices.length){
			getTimeStamp(indices[index]);
			index++;
			setTimeout(function(){initializeTimeStamps(index)}, 150)		
		}
	}
	
	function getTimeStamp(ex){
			$.ajax({
			url:"../ajax/getTimeStamps",
			data:{expData: {expId: expData[ex]} },
				type:"POST",
				dataType:"text",
				success: function(response){
					expData[ex+"time"] = response;
				},
				error: function(){
				}
			});	
	}
	
	function getFindTimeStamps(){
		$.ajax({
			url:"../ajax/getFindTimeStamps",
			data:{projectData: {projId: projectId} },
			type:"POST",
			dataType:"text",	
			success: function(response){
				lastFindTime = response;
			},
			error: function(response){
				lastFindTime = null;
			}
		});
		

	}
	
	function updateFinds(){
	$.ajax({
		url:"../ajax/updateFinds",
		data:{projectData: {projId: projectId, projTime: lastFindTime} },
		type:"POST",
		dataType:"json",	
			success: function(response){
				if(response != null && lastFindTime != null){
					for(find in response){
				
						addFind(finds.push(response[find])-1);
				
						}
					getFindTimeStamps();
				}
			}
		});
	}	
	
	function addFind(i){
			var point = new GLatLng(finds[i]['latitude']+1, finds[i]['longitude']+1);
			var marker = new GMarker(point);
			marker.findIndex = i;
			GEvent.addListener(marker, "click", function() {
			this.openInfoWindowHtml("<b>"+ finds[this.findIndex]['name'] + "</b><p>" + finds[this.findIndex]['description'] + '</p><p><a target="find" href="find.display?id=' + finds[this.findIndex]['guid'] + '">more info</a></p>');
			});

			$( ".selector" ).dialog({ closeText: 'hide' });

			markers.push(marker);
			lats.push(point.lat());
			lngs.push(point.lng());
				
			map.addOverlay(marker);		
	}
	
	function updateMap(toUpdate){
		if(toUpdate.length == 0)
			return;
		else{
			var curExp = toUpdate.shift();
			var index = $(curExp).attr('id');
			index = index.split("_");
			index = index[1];
			if($(curExp).attr('checked'))
				getNewPoints(index);
			setTimeout(function(){updateMap(toUpdate)},200);
		}
	}


	function initializeUpdate(){
		$(":checked").each(function(){
			initUpdate.push($(this));
		});
		updateMap(initUpdate);
	}
	
	function beginUpdate(){
		if($("#realTime").attr('checked')){
			updateFinds();
			initializeUpdate();
			}
			setTimeout(function(){beginUpdate()}, 20000);
		
	}
	
	

</script>

{/literal}

<h2>{$project.name}</h2>

<div id="secondary-menu">
	<a href="project.display?id={$project.id}">Project Home</a>
	<a href="#" onclick="fullScreen()">Full Screen</a>
</div>

<div id="map" class="map-window"></div>

<div class="expedition-list">
	<input type="checkbox" id="realTime"/>
	<label for="realTime" style="font-weight:bold; font-size:80%">Enable automatic updates</label>
	<h3>Available Expeditions</h3>
	<form name="expeditions_form" action="expedition.tracker">
	{php}
		$count_var = 0;
	{/php}
	{foreach from=$expeditions item=expedition key=k}
	
		<div class="list-item">
			
			<input type="checkbox" name="id[]" value="{$expedition.id}" id="check_{$k}" 
				onclick="toggleExpedition({$k})" checked="checked"/>
					<!--a href="expedition.tracker?id[]={$expedition.id}"-->
					{php}
						
						$color_count = count($this->get_template_vars('colors_decode'));
						$kmod = ($this->get_template_vars('k')) % $color_count;
						$this->assign("kmod", $count_var% $color_count);
						$count_var += 1;	
					{/php}
					
					<span class="legend-color" style="background-color:{$colors_decode.$kmod};color:{$colors_decode.$kmod}">__</span>
					{if $expedition.name=="Expedition"}
					<label for="check_{$k}" onMouseOver="showOptions(this);">{$expedition.name} {$expedition.id}</label>
					{else}
					<label for="check_{$k}" onMouseOver="showOptions(this);">{$expedition.name}</label>
					{/if}
					<!--/a-->
			<p class="description">{$expedition.description}</p>
			<a href="#" class="rename" style="display:none; padding-left:40px" value="Rename" onclick="rename_field(this);">Rename</a>
		</div><!--/list-item-->
	{/foreach}
	<input type="button" name="CheckAll" value="Check All"
		onClick="checkAll(expeditions_form);toggleAll();" />
	<input type="button" name="UnCheckAll" value="Uncheck All"
		onClick="uncheckAll(expeditions_form);toggleAll();"> <br />
	<!--<input type="submit" value="View Selected" />-->
	</form>
</div> <!-- /expedition-list-->

<div id="renameDialog" style="display:none;" title="Rename Your Expedition">
	<h5 id="errorMessage" style="color:red; display:none;" >Error connecting to server. Please try again later.</h5>
	<h5>Enter a new name for your expedition</h5>
	<input type="text" id="newName" style="width:275">
</div>

<div id="fullscreenDialog" class="fullscreen" style="display:none;" title="Available Expeditions">
	<input type="button" id="minimize" name="minScreen" value="Shrink Map" onClick="returnScreen()" />
</div>

{include file="footer.tpl"}

