<?

$params = array();
$params[":tn"]=$tn;
$params[':dpt_id']=$_SESSION["dpt_id"];

$sql=rtrim(file_get_contents('sql/bud_ru_st_ras.sql'));
$sql=stritr($sql,$params);
$bud_ru_st_ras = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_ru_st_ras', $bud_ru_st_ras);

$sql=rtrim(file_get_contents('sql/bud_funds.sql'));
$sql=stritr($sql,$params);
$funds = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('funds', $funds);

$sql=rtrim(file_get_contents('sql/bud_ru_zay_create_nets.sql'));
$sql=stritr($sql,$params);
$nets = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $nets);

$sql=rtrim(file_get_contents('sql/statya_list.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('statya_list', $data);

$sql=rtrim(file_get_contents('sql/payment_type.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('payment_type', $data);

$params1=array(':tn' => $tn);

$sql=rtrim(file_get_contents('sql/bud_ru_zay_create_zaylist.sql'));
$sql = stritr($sql, $params1);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

isset($data) ? $smarty->assign('bud_ru_zay_report', $data) : null;

$smarty->display('bud_ru_zay_create.html');

?>