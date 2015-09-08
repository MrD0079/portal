<?

//ses_req();
audit("открыл year_kpr","fin_plan");


if (isset($_REQUEST["nets"])){$_SESSION["nets"]=$_REQUEST["nets"];}else{if (isset($_SESSION["nets"])){$_REQUEST["nets"]=$_SESSION["nets"];}}
if (isset($_REQUEST["calendar_years"])){$_SESSION["calendar_years"]=$_REQUEST["calendar_years"];}else{if (isset($_SESSION["calendar_years"])){$_REQUEST["calendar_years"]=$_SESSION["calendar_years"];}}
if (isset($_REQUEST["tn_rmkk"])){$_SESSION["tn_rmkk"]=$_REQUEST["tn_rmkk"];}else{if (isset($_SESSION["tn_rmkk"])){$_REQUEST["tn_rmkk"]=$_SESSION["tn_rmkk"];}}
if (isset($_REQUEST["tn_mkk"])){$_SESSION["tn_mkk"]=$_REQUEST["tn_mkk"];}else{if (isset($_SESSION["tn_mkk"])){$_REQUEST["tn_mkk"]=$_SESSION["tn_mkk"];}}
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
!isset($_REQUEST["statya_list"]) ? $_REQUEST["statya_list"]=0: null;
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
	$_SESSION["statya_list"]=$_REQUEST["statya_list"];
	$_SESSION["groups"]=$_REQUEST["groups"];
	$_SESSION["payment_type"]=$_REQUEST["payment_type"];


	$sql_pfb=rtrim(file_get_contents('sql/year_kpr_pfb.sql'));
	$sql_fou=rtrim(file_get_contents('sql/year_kpr_fou.sql'));
	$sql_fos=rtrim(file_get_contents('sql/year_kpr_fos.sql'));
	$sql_svs=rtrim(file_get_contents('sql/year_kpr_svs.sql'));

	$sql_pfb_total=rtrim(file_get_contents('sql/year_kpr_pfb_total.sql'));
	$sql_fou_total=rtrim(file_get_contents('sql/year_kpr_fou_total.sql'));
	$sql_fos_total=rtrim(file_get_contents('sql/year_kpr_fos_total.sql'));
	$sql_svs_total=rtrim(file_get_contents('sql/year_kpr_svs_total.sql'));

	$params=array(
		':y'=>$_REQUEST["calendar_years"],
		':net'=>$_REQUEST["nets"],
		':groups'=>$groups_filter,
		':payment_type'=>$_REQUEST["payment_type"],
		':statya_list'=>$_REQUEST["statya_list"],
		':tn_rmkk'=>$_REQUEST["tn_rmkk"],
		':tn_mkk'=>$_REQUEST["tn_mkk"],
		':tn'=>$tn,
		':flt_id'=>$_REQUEST["flt_id"]
	);

	$sql_pfb=stritr($sql_pfb,$params);
	$sql_fou=stritr($sql_fou,$params);
	$sql_fos=stritr($sql_fos,$params);
	$sql_svs=stritr($sql_svs,$params);

	$sql_pfb_total=stritr($sql_pfb_total,$params);
	$sql_fou_total=stritr($sql_fou_total,$params);
	$sql_fos_total=stritr($sql_fos_total,$params);
	$sql_svs_total=stritr($sql_svs_total,$params);


/*


	echo $sql_pfb.";\n";
	echo $sql_fou.";\n";
	echo $sql_fos.";\n";
	echo $sql_svs.";\n";

	echo $sql_pfb_total.";\n";
	echo $sql_fou_total.";\n";
	echo $sql_fos_total.";\n";
	echo $sql_svs_total.";\n";


*/




	$data_pfb = $db->getAll($sql_pfb, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data_fou = $db->getAll($sql_fou, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data_fos = $db->getAll($sql_fos, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data_svs = $db->getAll($sql_svs, null, null, null, MDB2_FETCHMODE_ASSOC);

	$data_pfb_total = $db->getAll($sql_pfb_total, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data_fou_total = $db->getOne($sql_fou_total);
	$data_fos_total = $db->getOne($sql_fos_total);
	$data_svs_total = $db->getOne($sql_svs_total);

	foreach ($data_pfb as $k=>$v)
	{
		$d_pfb["plan_name"][$v["plan_type"]]=$v["plan_name"];
		$d_pfb["budget"][$v["my"]][$v["plan_type"]]=$v["budget"];
		$d_pfb["plan"][$v["my"]][$v["plan_type"]]=$v["plan"];
		$d_pfb["fakt"][$v["my"]]=$v["fakt"];
	}

	foreach ($data_pfb_total as $k=>$v)
	{
		$d_pfb_total["plan_name"][$v["plan_type"]]=$v["plan_name"];
		$d_pfb_total["budget"][$v["plan_type"]]=$v["budget"];
		$d_pfb_total["plan"][$v["plan_type"]]=$v["plan"];
		$d_pfb_total["fakt"]=$v["fakt"];
	}

	$smarty->assign('year_kpr_pfb', $d_pfb);
	$smarty->assign('year_kpr_fou', $data_fou);
	$smarty->assign('year_kpr_fos', $data_fos);
	$smarty->assign('year_kpr_svs', $data_svs);

	$smarty->assign('year_kpr_pfb_total', $d_pfb_total);
	$smarty->assign('year_kpr_fou_total', $data_fou_total);
	$smarty->assign('year_kpr_fos_total', $data_fos_total);
	$smarty->assign('year_kpr_svs_total', $data_svs_total);
}

$sql=rtrim(file_get_contents('sql/kk_flt_nets.sql'));
$params=array(':tn' => $tn);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('kk_flt_nets', $data);

$smarty->display('kk_start.html');
$smarty->display('year_kpr.html');
$smarty->display('kk_end.html');

?>