<?


audit("������ rep_compare_statya","fin_plan");


if (isset($_REQUEST["nets"])){$_SESSION["nets"]=$_REQUEST["nets"];}else{if (isset($_SESSION["nets"])){$_REQUEST["nets"]=$_SESSION["nets"];}}
if (isset($_REQUEST["calendar_years"])){$_SESSION["calendar_years"]=$_REQUEST["calendar_years"];}else{if (isset($_SESSION["calendar_years"])){$_REQUEST["calendar_years"]=$_SESSION["calendar_years"];}}
if (isset($_REQUEST["tn_rmkk"])){$_SESSION["tn_rmkk"]=$_REQUEST["tn_rmkk"];}else{if (isset($_SESSION["tn_rmkk"])){$_REQUEST["tn_rmkk"]=$_SESSION["tn_rmkk"];}}
if (isset($_REQUEST["tn_mkk"])){$_SESSION["tn_mkk"]=$_REQUEST["tn_mkk"];}else{if (isset($_SESSION["tn_mkk"])){$_REQUEST["tn_mkk"]=$_SESSION["tn_mkk"];}}
if (isset($_REQUEST["plan_type"])){$_SESSION["plan_type"]=$_REQUEST["plan_type"];}else{if (isset($_SESSION["plan_type"])){$_REQUEST["plan_type"]=$_SESSION["plan_type"];}}
if (isset($_REQUEST["month"])){$_SESSION["month"]=$_REQUEST["month"];}else{if (isset($_SESSION["month"])){$_REQUEST["month"]=$_SESSION["month"];}}
//if (isset($_REQUEST["orderby"])){$_SESSION["orderby"]=$_REQUEST["orderby"];}else{if (isset($_SESSION["orderby"])){$_REQUEST["orderby"]=$_SESSION["orderby"];}}
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
!isset($_REQUEST["month"]) ? $_REQUEST["month"]=0: null;
//!isset($_REQUEST["orderby"]) ? $_REQUEST["orderby"]=0: null;
!isset($_REQUEST["statya_list"]) ? $_REQUEST["statya_list"]=0: null;
!isset($_REQUEST["payment_type"]) ? $_REQUEST["payment_type"]=0: null;
!isset($_REQUEST["groups"]) ? $_REQUEST["groups"]=array(0): null;
!isset($_REQUEST["groups"]) ? $_REQUEST["groups"]=$groups: null;
$groups_filter = join($_REQUEST["groups"],',');


$sql=rtrim(file_get_contents('sql/calendar_years.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_years', $data);

$sql=rtrim(file_get_contents('sql/calendar_months.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_months', $data);




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


$sql=rtrim(file_get_contents('sql/plan_type_123.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('plan_type', $data);




if (isset($_REQUEST["calendar_years"]))
{


	$_SESSION["calendar_years"]=$_REQUEST["calendar_years"];
	$_SESSION["nets"]=$_REQUEST["nets"];
	$_SESSION["tn_rmkk"]=$_REQUEST["tn_rmkk"];
	$_SESSION["tn_mkk"]=$_REQUEST["tn_mkk"];
	$_SESSION["nets"]=$_REQUEST["nets"];
	$_SESSION["month"]=$_REQUEST["month"];
	$_SESSION["statya_list"]=$_REQUEST["statya_list"];
//	$_SESSION["orderby"]=$_REQUEST["orderby"];
	$_SESSION["groups"]=$_REQUEST["groups"]/*$groups_filter*/;
	$_SESSION["payment_type"]=$_REQUEST["payment_type"];
//	$_SESSION["plan_type"]=$_REQUEST["plan_type"];


	$sql=rtrim(file_get_contents('sql/rep_compare_statya.sql'));
	$sql_total=rtrim(file_get_contents('sql/rep_compare_statya_total.sql'));
	$params=array(
		':y'=>$_REQUEST["calendar_years"],
		':net'=>$_REQUEST["nets"],
		':statya_list'=>$_REQUEST["statya_list"],
		':month'=>$_REQUEST["month"],
		':groups'=>$groups_filter,
//		':orderby'=>$_REQUEST["orderby"],
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
$d[$v["id"]]["cost_item"]=$v["cost_item"];
$d[$v["id"]]["color"]=$v["color"];
$d[$v["id"]]["data"][$v["y"]][$v["plan_type"]]["cnt"]=$v["cnt"];
$d[$v["id"]]["data"][$v["y"]][$v["plan_type"]]["total"]=$v["total"];
}

foreach ($data_total as $k=>$v)
{
$d_total[0][$v["y"]][$v["plan_type"]]["cnt"]=$v["cnt"];
$d_total[0][$v["y"]][$v["plan_type"]]["total"]=$v["total"];
}

//print_r($d_total);

	if (isset($d)) {$smarty->assign('rep_compare_statya', $d);}
	if (isset($d_total)) {$smarty->assign('rep_compare_statya_total', $d_total);}
}

$sql=rtrim(file_get_contents('sql/kk_flt_nets.sql'));
$params=array(':tn' => $tn);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('kk_flt_nets', $data);


$smarty->display('kk_start.html');
$smarty->display('rep_compare_statya.html');
$smarty->display('kk_end.html');

?>