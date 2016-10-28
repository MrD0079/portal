<?

audit("открыл fin_plan_detail","fin_plan");

$sql=rtrim(file_get_contents('sql/groups.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('groups', $data);

foreach ($data as $k=>$v)
{
$groups[]=$v["id"];
}

InitRequestVar("calendar_years");
InitRequestVar("plan_type");
InitRequestVar("tn_rmkk",0);
InitRequestVar("tn_mkk",0);
InitRequestVar("nets",0);
InitRequestVar("month",0);
InitRequestVar("statya_list",0);
InitRequestVar("orderby",1);
InitRequestVar("distr_compensation",1);
InitRequestVar("payment_type",0);
InitRequestVar("flt_id",0);
InitRequestVar('payer',0);
InitRequestVar("groups",$groups);
$groups_filter = join($_REQUEST["groups"],',');
InitRequestVar("oms");
InitRequestVar("ome");


$sql=rtrim(file_get_contents('sql/calendar_years.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_years', $data);

$sql=rtrim(file_get_contents('sql/calendar_months.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_months', $data);

$sql=rtrim(file_get_contents('sql/groups.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('groups', $data);

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

$sql=rtrim(file_get_contents('sql/nets.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);

//$sql=rtrim(file_get_contents('sql/plan_type_123.sql'));
$sql=rtrim(file_get_contents('sql/plan_type.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('plan_type', $data);

if (isset($_REQUEST["calendar_years"])&&isset($_REQUEST["plan_type"]))
{
	$sql=rtrim(file_get_contents('sql/fin_plan_detail.sql'));
	$sql_total=rtrim(file_get_contents('sql/fin_plan_detail_total.sql'));
	$params=array(
		":dpt_id" => $_SESSION["dpt_id"],
		':y'=>$_REQUEST["calendar_years"],
		':net'=>$_REQUEST["nets"],
		':plan_type'=>$_REQUEST["plan_type"],
		':month'=>$_REQUEST["month"],
		':groups'=>$groups_filter,
		':statya_list'=>$_REQUEST["statya_list"],
		':orderby'=>$_REQUEST["orderby"],
		':distr_compensation'=>$_REQUEST["distr_compensation"],
		':payment_type'=>$_REQUEST["payment_type"],
		':tn_rmkk'=>$_REQUEST["tn_rmkk"],
		':tn_mkk'=>$_REQUEST["tn_mkk"],
		':flt_id'=>$_REQUEST["flt_id"],
		':payer'=>$_REQUEST["payer"],
		':oms'=>"'".$_REQUEST["oms"]."'",
		':ome'=>"'".$_REQUEST["ome"]."'",
		':tn'=>$tn,
	);
	$sql=stritr($sql,$params);
//print_r($params);
//echo $sql;
	$sql_total=stritr($sql_total,$params);
//echo $sql_total;
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data_total = $db->getAll($sql_total, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('fin_plan_detail', $data);
	$smarty->assign('fin_plan_detail_total', $data_total);
}

$sql=rtrim(file_get_contents('sql/kk_flt_nets.sql'));
$params=array(':tn' => $tn);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('kk_flt_nets', $data);

$sql=rtrim(file_get_contents('sql/distr_prot_di.sql'));
$p = array(":dpt_id" => $_SESSION["dpt_id"],':tn'=>$tn);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('payer', $data);

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$smarty->display('kk_start.html');
$smarty->display('fin_plan_detail.html');
$smarty->display('kk_end.html');

?>