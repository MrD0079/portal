<?


//ses_req();

audit("открыл zakaz_nal_report","zakaz_nal_report");



InitRequestVar("nets");
InitRequestVar("calendar_years");
InitRequestVar("plan_month");
InitRequestVar("tn_rmkk");
InitRequestVar("tn_mkk");

/*
!isset($_REQUEST["plan_month"]) ? $_REQUEST["plan_month"]=0: null;
!isset($_REQUEST["tn_rmkk"]) ? $_REQUEST["tn_rmkk"]=0: null;
!isset($_REQUEST["tn_mkk"]) ? $_REQUEST["tn_mkk"]=0: null;
!isset($_REQUEST["nets"]) ? $_REQUEST["nets"]=0: null;
*/

//!isset($_REQUEST["calendar_years"]) ? $_REQUEST["calendar_years"]=0: null;




$sql=rtrim(file_get_contents('sql/list_mkk_all.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$list_mkk_all = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_mkk_all', $list_mkk_all);


$sql=rtrim(file_get_contents('sql/zakaz_nal_report_nets.sql'));


$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);

$sql=rtrim(file_get_contents('sql/calendar_years.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_years', $data);

if (isset($_REQUEST["generate"])&&($_REQUEST["calendar_years"]>0))
{

		$sql=rtrim(file_get_contents('sql/zakaz_nal_report_table.sql'));
		$params=array(
			':y'=>$_REQUEST["calendar_years"],
			":plan_type" => 3,
			":plan_month" => $_REQUEST["plan_month"],
			':nets'=>$_REQUEST["nets"],
			':tn_rmkk'=>$_REQUEST["tn_rmkk"],
			':tn_mkk'=>$_REQUEST["tn_mkk"],
			':tn'=>$tn
		);
		$sql=stritr($sql,$params);
		$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//		$smarty->assign("data_table", $data);
//		print_r($data);





if (isset($data))
{
foreach ($data as $k=>$v)
{
//$d[$v["rmkk_name"]][$v["mkk_name"]]=$v["pay_type"];
$d[$v["rmkk_name"]]["data"][$v["mkk_name"]]["data"][$v["net_name"]][$v["pt_id"]]["pay_type"]=$v["pay_type"];
$d[$v["rmkk_name"]]["data"][$v["mkk_name"]]["data"][$v["net_name"]][$v["pt_id"]]["total"]=$v["total"];
}
}

if (isset($d))
{

$d1["total"]["1"]=0;
$d1["total"]["3"]=0;
foreach ($d as $k=>$v)
{
	$d[$k]["total"]["1"]=0;
	$d[$k]["total"]["3"]=0;
	foreach ($v["data"] as $k1=>$v1)
	{
		$d[$k]["data"][$k1]["total"]["1"]=0;
		$d[$k]["data"][$k1]["total"]["3"]=0;
		foreach ($v1["data"] as $k2=>$v2)
		{

			isset($v2["1"]["total"])?$d[$k]["data"][$k1]["total"]["1"]=$d[$k]["data"][$k1]["total"]["1"]+$v2["1"]["total"]:null;
			isset($v2["3"]["total"])?$d[$k]["data"][$k1]["total"]["3"]=$d[$k]["data"][$k1]["total"]["3"]+$v2["3"]["total"]:null;
		}
		$d[$k]["total"]["1"]=$d[$k]["total"]["1"]+$d[$k]["data"][$k1]["total"]["1"];
		$d[$k]["total"]["3"]=$d[$k]["total"]["3"]+$d[$k]["data"][$k1]["total"]["3"];
	}
	$d1["total"]["1"]=$d1["total"]["1"]+$d[$k]["total"]["1"];
	$d1["total"]["3"]=$d1["total"]["3"]+$d[$k]["total"]["3"];
}

//print_r($d);
$smarty->assign("data_table", $d);
$smarty->assign("d1", $d1);
}
}

$sql=rtrim(file_get_contents('sql/calendar_months.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_months', $data);


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



$smarty->display('kk_start.html');
$smarty->display('zakaz_nal_report.html');
$smarty->display('kk_end.html');

?>