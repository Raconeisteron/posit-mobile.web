<html>
	<head>
		<title>{$title|default:"positweb"}</title>
		<!--link rel="stylesheet" href="../res/style/basic.css"/-->
		<script src="../res/js/util.js"></script>
		<script src="../res/js/jquery-1.3.2.min.js"></script>
		<script type="text/javascript" src="http://www.google.com/jsapi?key={$smarty.const.GOOGLE_MAPS_KEY}"></script>
		<link rel="shortcut icon" href="/../../../../~cfei/icon.png" type="image/x-icon" /> 
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
	  <a href="http://www.hfoss.org"><img id="face" width="48" height="100" src="http://home.cs.trincoll.edu/~aalcorn/posit/hfoss-small.png"/></a> 
                          <a href="main" title="Home" rel="home"> 
            <img src="http://home.cs.trincoll.edu/~aalcorn/posit/posit.png" alt="Home" id="logo" /> 
          </a> 
        
        <div id="name-and-slogan"> 
 
        
                  <div id="site-slogan"> 
            Portable Open Search and Identification Tool          </div> 
        
        </div> <!-- /name-and-slogan --> 
 
      </div> <!-- /logo-title --> 
			

			

			
			      <div id="navigation" class="menu withprimary "> 
                  <div id="primary" class="clear-block"> 
                  <ul class="links"><li class="menu-120 active-trail first active"><a href="main" title="Home" class="active">Home</a></li> 
				<li class="menu-114">			
				<div id="loginStatus">
				{if $loggedIn}

				<div id="login-user">
					Logged in as <strong>{$loginEmail}</strong> 
				</div>
				<a href="logout" id="logout-link">log out</a>
				{else}
					<a href="login">Log in/register</a>
				{/if}
			</div> <!-- /loginStatus --></li>
<li class="menu-114"><a href="projects" title="Projects">Projects</a></li> 
<li class="menu-144"><a href="settings" title="Settings">Settings</a></li> 
<li class="menu-135"><a href="maps" title="Maps">Maps</a></li> 
{if $loginHasAdmin}
<li class="menu-134"><a href="admin" title="Administration">Administration</a></li> 
{/if}
<li class="menu-129"><a href="expeditions" title="Expeditions">Expeditions</a></li> 
</ul>          
</div>

        
              </div> <!-- /navigation --> 
		</div> <!-- /header -->
		<div id="content">
