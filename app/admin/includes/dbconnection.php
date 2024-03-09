<?php 
// DB credentials.
define('DB_HOST','10.0.141.26');
define('DB_USER','rajasekhar');
define('DB_PASS','rajasekhar');
define('DB_NAME','omrsdb');
// Establish database connection.
try
{
$dbh = new PDO("mysql:host=".DB_HOST.";dbname=".DB_NAME,DB_USER, DB_PASS,array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES 'utf8'"));
}
catch (PDOException $e)
{
exit("Error: " . $e->getMessage());
}
?>