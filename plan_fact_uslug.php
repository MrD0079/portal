<?
audit("открыл plan_fact_uslug","fin_plan");
InitRequestVar("nets",0);
InitRequestVar("calendar_years");
InitRequestVar("calendar_months");
InitRequestVar("tn_rmkk",0);
InitRequestVar("tn_mkk",0);
InitRequestVar("statya_list",0);
InitRequestVar("mgroups",1);
InitRequestVar("alg",1);
InitRequestVar("payment_type");
InitRequestVar("flt_id",0);
if (isset($_REQUEST["calendar_years"])&&isset($_REQUEST["generate"]))
{
	$sql=rtrim(file_get_contents('sql/plan_fact_uslug.sql'));
	$sql_st=rtrim(file_get_contents('sql/plan_fact_uslug_st.sql'));
	$sql_pay=rtrim(file_get_contents('sql/plan_fact_uslug_pay.sql'));
	$sql_net=rtrim(file_get_contents('sql/plan_fact_uslug_net.sql'));
	$sql_total=rtrim(file_get_contents('sql/plan_fact_uslug_total.sql'));
	$params=array(
		':dpt_id' => $_SESSION["dpt_id"],
		':y'=>$_REQUEST["calendar_years"],
		':nets'=>$_REQUEST["nets"],
		':calendar_months'=>$_REQUEST["calendar_months"],
		':statya_list'=>$_REQUEST["statya_list"],
		':mgroups'=>$_REQUEST["mgroups"],
		':alg'=>$_REQUEST["alg"],
		':payment_type'=>$_REQUEST["payment_type"],
		':tn_rmkk'=>$_REQUEST["tn_rmkk"],
		':tn_mkk'=>$_REQUEST["tn_mkk"],
		':tn'=>$tn,
		':flt_id'=>$_REQUEST["flt_id"]
	);
	$sql=stritr($sql,$params);
	$sql_st=stritr($sql_st,$params);
	$sql_pay=stritr($sql_pay,$params);
	$sql_net=stritr($sql_net,$params);
	$sql_total=stritr($sql_total,$params);
	//echo $sql_total;
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data_st = $db->getAll($sql_st, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data_pay = $db->getAll($sql_pay, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data_net = $db->getAll($sql_net, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data_total = $db->getRow($sql_total, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($data as $k=>$v)
	{
		$d[$v["id_net"]]["net_name"]=$v["net_name"];
		$d[$v["id_net"]]["data"][$v["payment_format"]]["data"][$v["statya"]]["cost_item"]=$v["cost_item"];
		$d[$v["id_net"]]["data"][$v["payment_format"]]["data"][$v["statya"]]["fin_cnt"]=$v["fin_cnt"];
		//$d[$v["id_net"]]["data"][$v["payment_format"]]["data"][$v["statya"]]["fin_price"]=$v["fin_price"];
		$d[$v["id_net"]]["data"][$v["payment_format"]]["data"][$v["statya"]]["fin_total"]=$v["fin_total"];
		$d[$v["id_net"]]["data"][$v["payment_format"]]["data"][$v["statya"]]["fin_bonus"]=$v["fin_bonus"];
		$d[$v["id_net"]]["data"][$v["payment_format"]]["data"][$v["statya"]]["o_cnt"]=$v["o_cnt"];
		//$d[$v["id_net"]]["data"][$v["payment_format"]]["data"][$v["statya"]]["o_price"]=$v["o_price"];
		$d[$v["id_net"]]["data"][$v["payment_format"]]["data"][$v["statya"]]["o_total"]=$v["o_total"];
		$d[$v["id_net"]]["data"][$v["payment_format"]]["data"][$v["statya"]]["o_bonus"]=$v["o_bonus"];
		$d[$v["id_net"]]["data"][$v["payment_format"]]["data"][$v["statya"]]["fu_cnt"]=$v["fu_cnt"];
		//$d[$v["id_net"]]["data"][$v["payment_format"]]["data"][$v["statya"]]["fu_price"]=$v["fu_price"];
		$d[$v["id_net"]]["data"][$v["payment_format"]]["data"][$v["statya"]]["fu_total"]=$v["fu_total"];
		$d[$v["id_net"]]["data"][$v["payment_format"]]["data"][$v["statya"]]["fu_bonus"]=$v["fu_bonus"];
	}
	foreach ($data_pay as $k=>$v)
	{
		$d[$v["id_net"]]["data"][$v["payment_format"]]["total"]=$v;
	}
	foreach ($data_net as $k=>$v)
	{
		$d[$v["id_net"]]["total"]=$v;
	}
	//print_r($data_pay);
	//print_r($d);
	isset($d)?$smarty->assign('fin_report', $d) : null;
	$smarty->assign('fin_report_st', $data_st);
	$smarty->assign('fin_report_pay', $data_pay);
	$smarty->assign('fin_report_total', $data_total);
}
$sql=rtrim(file_get_contents('sql/calendar_years.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_years', $data);
$sql=rtrim(file_get_contents('sql/calendar_months.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_months', $data);
$sql=rtrim(file_get_contents('sql/nets.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);
$sql=rtrim(file_get_contents('sql/statya_list.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('statya_list', $data);
$sql=rtrim(file_get_contents('sql/payment_type.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('payment_type', $data);
$sql=rtrim(file_get_contents('sql/list_rmkk.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$list_rmkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_rmkk', $list_rmkk);
$sql=rtrim(file_get_contents('sql/list_mkk.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$list_mkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_mkk', $list_mkk);
$sql=rtrim(file_get_contents('sql/kk_flt_nets.sql'));
$params=array(':tn' => $tn);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('kk_flt_nets', $data);
$smarty->display('kk_start.html');
$smarty->display('plan_fact_uslug.html');
$smarty->display('kk_end.html');
?>