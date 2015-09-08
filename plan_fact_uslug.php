<?

audit("открыл plan_fact_uslug","fin_plan");


if (isset($_REQUEST["nets"])){$_SESSION["nets"]=$_REQUEST["nets"];}else{if (isset($_SESSION["nets"])){$_REQUEST["nets"]=$_SESSION["nets"];}}
if (isset($_REQUEST["calendar_years"])){$_SESSION["calendar_years"]=$_REQUEST["calendar_years"];}else{if (isset($_SESSION["calendar_years"])){$_REQUEST["calendar_years"]=$_SESSION["calendar_years"];}}
if (isset($_REQUEST["tn_rmkk"])){$_SESSION["tn_rmkk"]=$_REQUEST["tn_rmkk"];}else{if (isset($_SESSION["tn_rmkk"])){$_REQUEST["tn_rmkk"]=$_SESSION["tn_rmkk"];}}
if (isset($_REQUEST["tn_mkk"])){$_SESSION["tn_mkk"]=$_REQUEST["tn_mkk"];}else{if (isset($_SESSION["tn_mkk"])){$_REQUEST["tn_mkk"]=$_SESSION["tn_mkk"];}}
if (isset($_REQUEST["neednmkk"])){$_SESSION["neednmkk"]=$_REQUEST["neednmkk"];}else{if (isset($_SESSION["neednmkk"])){$_REQUEST["neednmkk"]=$_SESSION["neednmkk"];}}
if (isset($_REQUEST["calendar_months"])){$_SESSION["calendar_months"]=$_REQUEST["calendar_months"];}else{if (isset($_SESSION["calendar_months"])){$_REQUEST["calendar_months"]=$_SESSION["calendar_months"];}}

if (isset($_REQUEST["statya_list"])){$_SESSION["statya_list"]=$_REQUEST["statya_list"];}else{if (isset($_SESSION["statya_list"])){$_REQUEST["statya_list"]=$_SESSION["statya_list"];}}
if (isset($_REQUEST["groups"])){$_SESSION["groups"]=$_REQUEST["groups"];}else{if (isset($_SESSION["groups"])){$_REQUEST["groups"]=$_SESSION["groups"];}}
if (isset($_REQUEST["payment_type"])){$_SESSION["payment_type"]=$_REQUEST["payment_type"];}else{if (isset($_SESSION["payment_type"])){$_REQUEST["payment_type"]=$_SESSION["payment_type"];}}

InitRequestVar("flt_id",0);


$sql=rtrim(file_get_contents('sql/groups.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('groups', $data);

foreach ($data as $k=>$v)
{
$groups[]=$v["id"];
}


!isset($_REQUEST["tn_rmkk"]) ? $_REQUEST["tn_rmkk"]=0: null;
!isset($_REQUEST["tn_mkk"]) ? $_REQUEST["tn_mkk"]=0: null;
!isset($_REQUEST["nets"]) ? $_REQUEST["nets"]=0: null;
!isset($_REQUEST["neednmkk"]) ? $_REQUEST["neednmkk"]=0: null;
!isset($_REQUEST["calendar_months"]) ? $_REQUEST["calendar_months"]=0: null;

!isset($_REQUEST["statya_list"]) ? $_REQUEST["statya_list"]=0: null;
!isset($_REQUEST["payment_type"]) ? $_REQUEST["payment_type"]=0: null;
!isset($_REQUEST["groups"]) ? $_REQUEST["groups"]=array(0): null;
!isset($_REQUEST["groups"]) ? $_REQUEST["groups"]=$groups: null;
$groups_filter = join($_REQUEST["groups"],',');


if (isset($_REQUEST["calendar_years"])&&isset($_REQUEST["generate"]))
{
	$_SESSION["calendar_years"]=$_REQUEST["calendar_years"];
	$_SESSION["tn_rmkk"]=$_REQUEST["tn_rmkk"];
	$_SESSION["tn_mkk"]=$_REQUEST["tn_mkk"];
	$_SESSION["nets"]=$_REQUEST["nets"];
	$_SESSION["neednmkk"]=$_REQUEST["neednmkk"];

	$_SESSION["statya_list"]=$_REQUEST["statya_list"];
	$_SESSION["groups"]=$_REQUEST["groups"]/*$groups_filter*/;
	$_SESSION["payment_type"]=$_REQUEST["payment_type"];


	$sql=rtrim(file_get_contents('sql/plan_fact_uslug.sql'));
	$sql_total=rtrim(file_get_contents('sql/plan_fact_uslug_total.sql'));
	$params=array(
		':dpt_id' => $_SESSION["dpt_id"],
		':y'=>$_REQUEST["calendar_years"],
		':nets'=>$_REQUEST["nets"],
		':neednmkk'=>$_REQUEST["neednmkk"],
		':calendar_months'=>$_REQUEST["calendar_months"],
		':statya_list'=>$_REQUEST["statya_list"],
		':groups'=>$groups_filter,
		':payment_type'=>$_REQUEST["payment_type"],
		':tn_rmkk'=>$_REQUEST["tn_rmkk"],
		':tn_mkk'=>$_REQUEST["tn_mkk"],
		':tn'=>$tn,
		':flt_id'=>$_REQUEST["flt_id"]
	);
	$sql=stritr($sql,$params);
//echo $sql;
	$sql_total=stritr($sql_total,$params);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data_total = $db->getAll($sql_total, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($data as $k=>$v)
	{
$d[$v["id_net"]]["net_name"]=$v["net_name"];
$d[$v["id_net"]]["data"][$v["statya"]]["cost_item"]=$v["cost_item"];
$d[$v["id_net"]]["data"][$v["statya"]]["o_cnt"]=$v["o_cnt"];
$d[$v["id_net"]]["data"][$v["statya"]]["o_price"]=$v["o_price"];
$d[$v["id_net"]]["data"][$v["statya"]]["o_total"]=$v["o_total"];
$d[$v["id_net"]]["data"][$v["statya"]]["o_bonus"]=$v["o_bonus"];
$d[$v["id_net"]]["data"][$v["statya"]]["fu_cnt"]=$v["fu_cnt"];
$d[$v["id_net"]]["data"][$v["statya"]]["fu_price"]=$v["fu_price"];
$d[$v["id_net"]]["data"][$v["statya"]]["fu_total"]=$v["fu_total"];
$d[$v["id_net"]]["data"][$v["statya"]]["fu_bonus"]=$v["fu_bonus"];
	}
//	print_r($data);
//	print_r($d);
	if (isset($d))
	{
		$smarty->assign('fin_report', $d);
	}
	$smarty->assign('fin_report_total', $data_total[0]);
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