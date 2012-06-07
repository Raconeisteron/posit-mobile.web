{include file="header.tpl" title=$project.name tab="project"}

{literal}
	<style type="text/css">
		
		.expedition-list {
			float:right;
			width:20%;
		}
		
		.map-window {
			float:left;
		}
		
		.list-item {
			border:none;
			padding:0;
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
		     return zoomLevel; 
		}
		
		function toggleExpedition(id) {
			check_box = document.getElementById('check_' + id);
			if (check_box.checked){
				// display the expedition
				alert(id);

			}
			else {
				// remove the expedition
				alert("unchecked");
			}
		}
		

	   google.load("maps", "2.x");
	   {/literal}
	   var expedition_points = eval('{$expedition_points}');
	   //alert(expedition_points[0]);
	   //document.write(expedition_points[0]['latitude']);
	   {literal}
	   // Call this function when the page has been loaded
	   function initialize() {
	   		var map = new google.maps.Map2(document.getElementById("map"));
			
	   {/literal}
			var pointSpan = max([
				distanceInMiles({$extremes.north}, {$extremes.east}, {$extremes.north}, {$extremes.west}),
				distanceInMiles({$extremes.north}, {$extremes.east}, {$extremes.south}, {$extremes.east})
				]);
			
			var zoomLevel = null;
		    
			zoomLevel = getZoomLevel(pointSpan);
		     
		//	map.setCenter(center, zoomLevel + 1);
			
		   	map.setCenter(new GLatLng({$geocenter.lat}, {$geocenter.long}), zoomLevel);

			var location_data = eval('{$location_data}');
			var finds = eval('{$finds}');
		{literal}
			var expeditions = [];
	/*		for (exp_pointset in expedition_points) {
				var temp_array = [];
				for (exp_point in exp_pointset) {
					//var temp_point = new GLatLng([exp_point['latitude'],exp_point['longitude']],"#ededed",10);
					temp_point = new GLatLng(exp_point['latitude'],exp_point['longitude']);
					temp_array.push(temp_point);
					//document.getElementById('map').style.border = '10px solid red';
				}
				var polyline = new GPolyline(temp_array);
				map.addOverlay(polyline);
				expeditions.push(polyline);
			} */
			var markers = [];
			var lats = [];
			var lngs = [];
			 
			var redIcon = new GIcon(G_DEFAULT_ICON);
			redIcon.image = "http://posit.hfoss.org/demo/res/image/redmark.png";
			redIcon.iconSize = new GSize(14, 22);
			redIcon.iconAnchor = new GPoint(7, 21);
			redIcon.shadow = "http://posit.hfoss.org/demo/res/image/redshadow.png";
			redIcon.shadowSize = new GSize(39, 31);
			                
			// Set up our GMarkerOptions object
			//markerOptions = { icon:redIcon };
		     	     
			for(var i in finds) {
				var point = new GLatLng(finds[i]['latitude'], finds[i]['longitude']);
				var marker = new GMarker(point);
				marker.findIndex = i;
				GEvent.addListener(marker, "click", function() {
					this.openInfoWindowHtml("<b>"+ finds[this.findIndex]['name'] + "</b><p>" + finds[this.findIndex]['description'] + '</p><p><a target="find" href="find.display?id=' + finds[this.findIndex]['guid'] + '">more info</a></p>');
				});
				
				
				markers.push(marker);
				lats.push(point.lat());
				lngs.push(point.lng());
				
				map.addOverlay(marker);
			}
		     
		    var mapControl = new GMapTypeControl();
			map.addControl(mapControl);
			map.addControl(new GLargeMapControl());
			
		}  
		
		google.setOnLoadCallback(initialize);

	</script>
{/literal}

<h2>{$project.name}</h2>

<div id="secondary-menu">
	<a href="project.display?id={$project.id}">Project Home</a>
</div>

{if $expeditions}
	<div class="expedition-list">
		<h3>Available Expeditions</h3>
		<form name="expeditions" action="expedition.tracker">
		{foreach from=$expeditions item=expedition}
			<div class="list-item">
				<input type="checkbox" name="id[]" value="{$expedition.id}" id="check_{$expedition.id}" 
					onclick="toggleExpedition({$expedition.id})"/>
						<!--a href="expedition.tracker?id[]={$expedition.id}"-->
						<label for="check_{$expedition.id}">{$expedition.name} {$expedition.id}</label>
						<!--/a-->
				<p class="description">{$expedition.description}</p>
			</div><!--/list-item-->
		{/foreach}
		<input type="button" name="CheckAll" value="Check All"
			onClick="checkAll(expeditions)">
		<input type="button" name="UnCheckAll" value="Uncheck All"
			onClick="uncheckAll(expeditions)"> <br />
		<input type="submit" value="View Selected" />
		</form>
	</div> <!-- /expedition-list-->
	{else}
		<em>There are no expeditions on this project yet.</em>
{/if}

<div id="map" style="width:75%; height:100%"></div>


{include file="footer.tpl"}
