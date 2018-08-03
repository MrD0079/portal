<?


audit("открыл budget_gruppa","fin_plan");


if (isset($_REQUEST["nets"])){$_SESSION["nets"]=$_REQUEST["nets"];}else{if (isset($_SESSION["nets"])){$_REQUEST["nets"]=$_SESSION["nets"];}}
if (isset($_REQUEST["calendar_years"])){$_SESSION["calendar_years"]=$_REQUEST["calendar_years"];}else{if (isset($_SESSION["calendar_years"])){$_REQUEST["calendar_years"]=$_SESSION["calendar_years"];}}
if (isset($_REQUEST["tn_rmkk"])){$_SESSION["tn_rmkk"]=$_REQUEST["tn_rmkk"];}else{if (isset($_SESSION["tn_rmkk"])){$_REQUEST["tn_rmkk"]=$_SESSION["tn_rmkk"];}}
if (isset($_REQUEST["tn_mkk"])){$_SESSION["tn_mkk"]=$_REQUEST["tn_mkk"];}else{if (isset($_SESSION["tn_mkk"])){$_REQUEST["tn_mkk"]=$_SESSION["tn_mkk"];}}
if (isset($_REQUEST["plan_type"])){$_SESSION["plan_type"]=$_REQUEST["plan_type"];}else{if (isset($_SESSION["plan_type"])){$_REQUEST["plan_type"]=$_SESSION["plan_type"];}}
if (isset($_REQUEST["month"])){$_SESSION["month"]=$_REQUEST["month"];}else{if (isset($_SESSION["month"])){$_REQUEST["month"]=$_SESSION["month"];}}
if (isset($_REQUEST["statya_list"])){$_SESSION["statya_list"]=$_REQUEST["statya_list"];}else{if (isset($_SESSION["statya_list"])){$_REQUEST["statya_list"]=$_SESSION["statya_list"];}}
if (isset($_REQUEST["orderby"])){$_SESSION["orderby"]=$_REQUEST["orderby"];}else{if (isset($_SESSION["orderby"])){$_REQUEST["orderby"]=$_SESSION["orderby"];}}
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
!isset($_REQUEST["statya_list"]) ? $_REQUEST["statya_list"]=0: null;
!isset($_REQUEST["orderby"]) ? $_REQUEST["orderby"]=1: null;
!isset($_REQUEST["payment_type"]) ? $_REQUEST["payment_type"]=0: null;
!isset($_REQUEST["groups"]) ? $_REQUEST["groups"]=$groups: null;
$groups_filter = join($_REQUEST["groups"],',');


$sql=rtrim(file_get_contents('sql/calendar_years.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_years', $data);

$sql=rtrim(file_get_contents('sql/calendar_months.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_months', $data);

$sql=rtrim(file_get_contents('sql/groups.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('groups', $data);

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




if (isset($_REQUEST["calendar_years"])&&isset($_REQUEST["plan_type"]))
{


	$_SESSION["calendar_years"]=$_REQUEST["calendar_years"];
	$_SESSION["nets"]=$_REQUEST["nets"];
	$_SESSION["tn_rmkk"]=$_REQUEST["tn_rmkk"];
	$_SESSION["tn_mkk"]=$_REQUEST["tn_mkk"];
	$_SESSION["nets"]=$_REQUEST["nets"];
	$_SESSION["month"]=$_REQUEST["month"];
	$_SESSION["statya_list"]=$_REQUEST["statya_list"];
	$_SESSION["orderby"]=$_REQUEST["orderby"];
	$_SESSION["groups"]=$_REQUEST["groups"];
	$_SESSION["payment_type"]=$_REQUEST["payment_type"];
	$_SESSION["plan_type"]=$_REQUEST["plan_type"];


	$sql=rtrim(file_get_contents('sql/budget_gruppa.sql'));
	$sql_total=rtrim(file_get_contents('sql/budget_gruppa_total.sql'));
	$params=array(
		':y'=>$_REQUEST["calendar_years"],
		':net'=>$_REQUEST["nets"],
		':month'=>$_REQUEST["month"],
		':plan_type'=>$_REQUEST["plan_type"],
		':groups'=>$groups_filter,
		':orderby'=>$_REQUEST["orderby"],
		':payment_type'=>$_REQUEST["payment_type"],
		':tn_rmkk'=>$_REQUEST["tn_rmkk"],
		':tn_mkk'=>$_REQUEST["tn_mkk"],
		':tn'=>$tn,
		':flt_id'=>$_REQUEST["flt_id"]
	);
	$sql=stritr($sql,$params);
	//echo $sql;
	//exit;
	$sql_total=stritr($sql_total,$params);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data_total = $db->getAll($sql_total, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('budget_gruppa', $data);
	$smarty->assign('budget_gruppa_total', $data_total);
}

$sql=rtrim(file_get_contents('sql/kk_flt_nets.sql'));
$params=array(':tn' => $tn);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('kk_flt_nets', $data);

$smarty->display('kk_start.html');
$smarty->display('budget_gruppa.html');
$smarty->display('kk_end.html');

?>