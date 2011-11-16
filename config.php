<?php
// Copy this to config.php and edit.

// base uri of server instance
define(SERVER_BASE_URI, "http://turing.cs.trincoll.edu/~ram/positweb/web/main");
// database hostname
define("DB_HOST", "storage1.cs.trincoll.edu");
// database username
define("DB_USER", "posit");
// database password
define("DB_PASS", "posit157");
// database name
define("DB_NAME", "posit_x");

/* dg6TR9ar3GX2 */

//enable if you want to keep the debug symbols on
// note: very insecure
define("DEBUG", true);

// enable if you want to keep log
// @todo need to do this in many levels - think Log4J
define("LOG", true);
if (LOG){
define("LOG_FILE", "./logs/log.txt");
}

define ("GOOGLE_MAPS_KEY", "ABQIAAAAl-U6nA2OYa7Leg_UhWuVUxQrF6HC-Cb-X9u3nmmC08_mW1SFYxRCIDufEZOnxU8bzmhfi6oBv_xUtA");

define ("POSIT_ANDROID_CODE", "/build_dir/posit-android");
define ("ANDROID_SDK_DIR", "/build_dir/android-sdk");
define ("ANT_EXEC", "/usr/bin/ant");

?>