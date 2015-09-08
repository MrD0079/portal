<?
	$params=array(
		':month_list' => "'".$_REQUEST["month_list"]."'",
		':dpt_id' => $_SESSION["dpt_id"],
		':kk' => $_REQUEST["kk"],
		':fund' => $_REQUEST["fund"],
		':db' => $_REQUEST["db"]
	);

//ses_req();

	$sql=rtrim(file_get_contents('sql/bud_funds_limits_get_val.sql'));
	$sql=stritr($sql,$params);
	$x = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('x', $x);
	$smarty->display('bud_funds_limits_get_val.html');
?>