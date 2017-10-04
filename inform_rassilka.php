<?
require_once "function.php";
require_once "local_functions.php";
require_once 'MDB2.php';
$dsn = 'oci8://persik:razvitie@'.ZAOIBM;
$db =& MDB2::connect($dsn);
$db->loadModule('Extended');
$sql=rtrim(file_get_contents('sql/inform_rassilka.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach($data as $key=>$val)
{
	send_mail($val["e_mail"],"Сроки подачи отчетности",nl2br($val["pos_msg"]),null);
}
?>