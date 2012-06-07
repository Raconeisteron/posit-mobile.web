{include file="header.tpl" title=$expedition.name tab="projects"}
<!--<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;sensor=false&amp;-->
<!--key={$smarty.const.GOOGLE_MAPS_KEY}"/>-->
<h2>{$project.name}</h2>
<div id='secondary-menu'>
	<a href="expeditions?id={$project.id}">Back To Expeditions</a>
	<a href="project.display?id={$project.id}">Project Home</a>
</div>
<br />
{literal}
<script type="text/javascript"> 
google.load("maps", "2.x");

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
	
	function distanceInMiles(lat1, lng1, lat2, lng2) {
		return (3958.75 * Math.acos(Math.sin(lat1 / 57.2958) * Math.sin(lat2 / 57.2958) + Math.cos(lat1 / 57.2958) * Math.cos(lat2 / 57.2958) * Math.cos(lng2 / 57.2958 - lng1 / 57.2958)));
	}
		
		
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
	
    function initialize() {
      
        var map = new google.maps.Map2(document.getElementById("map_canvas"));
        {/literal}
        {foreach from=$expeditions item=expedition key=k}
        var polyline = new GPolyline([
           	{foreach from=$expedition item=expeditionPoint}
        new GLatLng({$expeditionPoint.latitude},{$expeditionPoint.longitude}),
        	{/foreach}
         ], "#{$colors.$k}", 10);
        map.addOverlay(polyline);
        {/foreach}
        {literal}
		map.setUIToDefault();
		{/literal}
		
		var pointSpan = max([
			distanceInMiles({$extremes.north}, {$extremes.east}, {$extremes.north}, {$extremes.west}),
			distanceInMiles({$extremes.north}, {$extremes.east}, {$extremes.south}, {$extremes.east})
			]);
		
		var zoomLevel = getZoomLevel(pointSpan);

    	map.setCenter(new GLatLng({$geocenter.lat}, {$geocenter.long}), zoomLevel);
		{literal}
    }
 	   google.setOnLoadCallback(initialize);
        	   
    </script> 
    {/literal}
	<!--ORIGINALLY width=500px and height=300px-->
	<div id="map_canvas" style="width: 100%; height: 100%"></div>

{include file="footer.tpl"}