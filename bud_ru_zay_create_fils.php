<?

$params = array();
$params[":tn"]=$tn;
$params[":dt"]="'".$_REQUEST['dt']."'";

$sql=rtrim(file_get_contents('sql/bud_ru_zay_create_fils.sql'));
$sql=stritr($sql,$params);
$fil = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('fil', $fil);

$smarty->display('bud_ru_zay_create_fils.html');

?>