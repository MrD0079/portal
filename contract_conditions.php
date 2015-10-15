<?
if (isset($_REQUEST["save"]))
{
	$keys=array(
		"id_net" => $_REQUEST["nets"],
		"plan_type" => 2,
		"year" => $_REQUEST["calendar_years"]
	);
	$vals=array(
		"ok_fin_man" => $_REQUEST["ok_fin_man"]
	);
	Table_Update ("nets_plan_year", $keys, $vals);
}
else
{
	if (isset($_REQUEST["calendar_years"])&&isset($_REQUEST["nets"])&&isset($_REQUEST["generate"]))
	{
		$params=array(
			':y'=>$_REQUEST["calendar_years"],
			':nets'=>$_REQUEST["nets"],
			':tn'=>$tn
		);
		$sql_fin_plan=rtrim(file_get_contents('sql/contract_conditions_fin_plan.sql'));
		$sql_detail=rtrim(file_get_contents('sql/contract_conditions_dog_detail.sql'));
		$sql_detail_total=rtrim(file_get_contents('sql/contract_conditions_dog_detail_total.sql'));
		$sql_fin_plan=stritr($sql_fin_plan,$params);
		$sql_detail=stritr($sql_detail,$params);
		$sql_detail_total=stritr($sql_detail_total,$params);
		$fin_plan = $db->getRow($sql_fin_plan, null, null, null, MDB2_FETCHMODE_ASSOC);
		$detail = $db->getAll($sql_detail, null, null, null, MDB2_FETCHMODE_ASSOC);
		$detail_total = $db->getRow($sql_detail_total, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('fin_plan', $fin_plan);
		$smarty->assign('detail', $detail);
		$smarty->assign('detail_total', $detail_total);
		$sql=rtrim(file_get_contents('sql/nets_plan_year.sql'));
		$params=array(':year'=>$_REQUEST["calendar_years"],":plan_type" => 2,':net'=>$_REQUEST["nets"]);
		$sql=stritr($sql,$params);
		$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('nets_plan_year', $data);
	}
	$sql=rtrim(file_get_contents('sql/calendar_years.sql'));
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('calendar_years', $data);
	$sql=rtrim(file_get_contents('sql/nets.sql'));
	$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
	$sql=stritr($sql,$params);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('nets', $data);
	$smarty->display('kk_start.html');
	$smarty->display('contract_conditions.html');
	$smarty->display('kk_end.html');
}
?>