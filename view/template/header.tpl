<html>
	<head>
		<title>{$title|default:"positweb"}</title>
		<!--link rel="stylesheet" href="../res/style/basic.css"/-->
		<script src="../res/js/util.js"></script>
		<script src="../res/js/jquery-1.3.2.min.js"></script>
		<script type="text/javascript" src="http://www.google.com/jsapi?key={$smarty.const.GOOGLE_MAPS_KEY}"></script>
		<link rel="shortcut icon" href="../res/image/icon.png" type="image/x-icon" /> 
		<link type="text/css" rel="stylesheet" media="all" href="../res/style/css/node.css" /> 
		<link type="text/css" rel="stylesheet" media="all" href="../res/style/css/defaults.css" /> 
		<link type="text/css" rel="stylesheet" media="all" href="../res/style/css/system.css" /> 
		<link type="text/css" rel="stylesheet" media="all" href="../res/style/css/system-menus.css" /> 
		<link type="text/css" rel="stylesheet" media="all" href="../res/style/css/user.css" /> 
		<link type="text/css" rel="stylesheet" media="all" href="../res/style/css/html-elements.css" /> 
		<link type="text/css" rel="stylesheet" media="all" href="../res/style/css/tabs.css" /> 
		<link type="text/css" rel="stylesheet" media="all" href="../res/style/css/block-editing.css" /> 
		<link type="text/css" rel="stylesheet" media="all" href="../res/style/css/layout-garland.css" /> 
		<link type="text/css" rel="stylesheet" media="all" href="../res/style/css/icons.css" /> 
		<link type="text/css" rel="stylesheet" media="all" href="../res/style/css/zen-classic.css" /> 
		<link type="text/css" rel="stylesheet" media="print" href="../res/style/css/print.css" />
	</head>
	<body{$body_attributes}>
		<div id="header">
		
		      <div id="skip-nav"><a href="#content">Skip to Main Content</a></div> 

						 
      <div id="logo-title"> 
	  <a href="http://www.hfoss.org"><img id="face" width="48" height="100" src="../res/style/images/hfoss-small.png"/></a> 
                          <a href="main" title="Home" rel="home"> 
            <img src="../res/style/images/posit.png" alt="Home" id="logo" /> 
          </a> 
        
        <div id="name-and-slogan"> 
 
        
                  <div id="site-slogan"> 
            Portable Open Search and Identification Tool          </div> 
        
        </div> <!-- /name-and-slogan --> 
 
      </div> <!-- /logo-title --> 
			

			

			
			      <div id="navigation" class="menu withprimary "> 
                  <div id="primary" class="clear-block"> 
                  <ul class="links"><li><a href="main" title="Home" {if $tab=="home" || $tab==""} class="active"{/if}>Home</a></li> 
				<li class="menu-114">			
				<div id="loginStatus">
				{if $loggedIn}

				<a href="logout" id="logout-link">log out</a>
				<div id="login-user">Logged in as <strong>{$loginEmail}</strong> </div>
				{else}
					<a href="login">Log in/register</a>
				{/if}
			</div> <!-- /loginStatus --></li>
<li><a href="projects" title="Projects" {if $tab== "projects"}class="active"{/if} >Projects</a></li> 
<li><a href="settings" title="Settings" {if $tab== "settings"}class="active"{/if}  >Settings</a></li> 
<!--<li><a href="maps" title="Maps" {if $tab== "maps"}class="active"{/if}>Maps</a></li>--> 
{if $loginHasAdmin}
<li><a href="admin" title="Administration"{if $tab== "admin"}class="active"{/if}>Administration</a></li> 
{/if}
<!--<li><a href="expeditions" title="Expeditions">Expeditions</a></li> -->
</ul>          
</div>

        
              </div> <!-- /navigation --> 
		</div> <!-- /header -->
		<div id="content">
		{if $error}
		<div class="error">{$error}</div>
		{/if}
			
