<?

$params=array(
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':dt' => "'".$_REQUEST["dt"]."'",
	':tp_kod' => "'".$_REQUEST["tp_kod"]."'",
);

$sql = rtrim(file_get_contents('sql/bud_svod_tus_tp_get_val.sql'));
$sql=stritr($sql,$params);
$x = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('x', $x);

$smarty->display('bud_svod_tus_tp_get_val.html');

?>