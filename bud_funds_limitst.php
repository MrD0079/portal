<?
	$params=array(
		':month_list' => "'".$_REQUEST["month_list"]."'",
		':dpt_id' => $_SESSION["dpt_id"],
		':kk' => $_REQUEST["kk"]
	);

	$sql = rtrim(file_get_contents('sql/bud_funds_limits_f_list.sql'));
	$sql=stritr($sql,$params);
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('f_list', $res);

	$sql=rtrim(file_get_contents('sql/bud_funds_limits_bt.sql'));
	$sql=stritr($sql,$params);
	$x = $db->getOne($sql);
	$smarty->assign('plan', $x);

	$sql=rtrim(file_get_contents('sql/bud_funds_limits_ft.sql'));
	$sql=stritr($sql,$params);
	$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('f', $x);

	$smarty->display('bud_funds_limitst.html');
?>