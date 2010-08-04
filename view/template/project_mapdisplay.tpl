{include file="header.tpl" title=$project.name tab="maps"}
<h2>{$project.name}</h2>
<div id="secondary-menu">
<a href="project.display?id={$project.id}">Project Home</a>
<!--
<a href="projects">All Projects</a>
<a href="project.delete?id={$project.id}">Delete Project</a>
<a href="project.export?id={$project.id}">Export Project</a>
<a href="project.mapdisplay?id={$project.id}">Show Map</a>
<a href="expeditions?id={$project.id}">Expeditions</a>
-->
</div>
    <script>
    {literal}
	function sum(a) {
		var sum = 0;
		for(var i in a)
			sum += a[i];
		return sum;
	}
	
	function avg(a) {
		if(a.length > 0)
			return sum(a)/a.length;
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

   google.load("maps", "2.x");
   // Call this function when the page has been loaded
   function initialize() {
	{/literal}
	var location_data = eval('{$location_data}');
	var finds = eval('{$finds}');
	{literal}
	var map = new google.maps.Map2(document.getElementById("map"));
	
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
/*     
	var center = new GLatLng(avg([max(lats), min(lats)]),avg([max(lngs), min(lngs)]));
	var pointSpan = max([
		distanceInMiles(max(lats), max(lngs), min(lats), max(lngs)),
		distanceInMiles(max(lats), max(lngs), max(lats), min(lngs))
	]);
*/
	{/literal}
	var pointSpan = max([
		distanceInMiles({$extremes.north}, {$extremes.east}, {$extremes.north}, {$extremes.west}),
		distanceInMiles({$extremes.north}, {$extremes.east}, {$extremes.south}, {$extremes.east})
		]);
	
	var zoomLevel = null;
     
	zoomLevel = getZoomLevel(pointSpan);
     
//	map.setCenter(center, zoomLevel + 1);
	
   	map.setCenter(new GLatLng({$geocenter.lat}, {$geocenter.long}), zoomLevel);
	{literal}
     
    var mapControl = new GMapTypeControl();
	map.addControl(mapControl);
	map.addControl(new GLargeMapControl());
	
	}  
	google.setOnLoadCallback(initialize);
   
	{/literal}
   </script>
   <body>
   <!--ORIGINALLY width=500px and height=400px-->
   <div id="map" style="width: 100%; height: 60%"></div>

    <div id="searchcontrol"></div>
   </body>
{include file="footer.tpl"}