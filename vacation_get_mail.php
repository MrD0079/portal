<?

header("Content-Type: text/html; charset=\"windows-1251\"");
header("Cache-Control: no-store, no-cache,  must-revalidate"); 
header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");


require_once "function.php";
require_once "local_functions.php";
require_once 'MDB2.php';
$dsn = 'oci8://persik:razvitie@'.ZAOIBM;
$db =& MDB2::connect($dsn);
$db->loadModule('Extended');
$db->loadModule('Function');


echo $db->getOne('SELECT e_mail FROM user_list WHERE tn = '.$_REQUEST["tn"].' AND e_mail IS NOT NULL');

?>