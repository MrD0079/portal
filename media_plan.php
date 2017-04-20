<?
audit("открыл media_plan","media_plan");

InitRequestVar("calendar_years");
InitRequestVar("plan_month");
InitRequestVar("tn_rmkk");
InitRequestVar("tn_mkk");
InitRequestVar("byyear",0);
InitRequestVar("nets",0);
InitRequestVar("statya_list",null,true);
InitRequestVar("detalisation",0);

/*
ses_req();

$serialized = serialize($_REQUEST["statya_list"]);
echo $serialized;

$deserialized = unserialize($serialized);
print_r($deserialized);

$_REQUEST["statya_list"] = $deserialized;*/

$statya_list_flt = is_array($_REQUEST["statya_list"]) ? join($_REQUEST["statya_list"],',') : "''"; 
//$groups = is_array($_REQUEST["groups"]) ? join($_REQUEST["groups"],',') : "''"; 

if (isset($_REQUEST["generate"])&&($_REQUEST["calendar_years"]>0))
{
	$sql0=rtrim(file_get_contents('sql/media_plan_table0.sql'));
	$sql1=rtrim(file_get_contents('sql/media_plan_table1.sql'));
	$sql2=rtrim(file_get_contents('sql/media_plan_table2.sql'));
	$sql3=rtrim(file_get_contents('sql/media_plan_table3.sql'));
	$params=array(
            ':byyear'=>$_REQUEST["byyear"],
            ':y'=>$_REQUEST["calendar_years"],
            ':plan_month' => $_REQUEST["plan_month"],
            ':net'=>$_REQUEST["nets"],
            ':tn_rmkk'=>$_REQUEST["tn_rmkk"],
            ':tn_mkk'=>$_REQUEST["tn_mkk"],
            //':groups'=>$groups,
            ':statya_list'=>$statya_list_flt,
            ':tn'=>$tn
	);
        //print_r($params);
	$sql0=stritr($sql0,$params);
	$sql1=stritr($sql1,$params);
	$sql2=stritr($sql2,$params);
	$sql3=stritr($sql3,$params);
	/*echo $sql0.";";
	echo $sql1.";";
	echo $sql2.";";
	echo $sql3.";";*/
	$data0 = $db->getAll($sql0, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data1 = $db->getAll($sql1, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data2 = $db->getAll($sql2, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data3 = $db->getAll($sql3, null, null, null, MDB2_FETCHMODE_ASSOC);
		foreach ($data3 as $k=>$v)
		{
			$d[$v["tn_nmkk_net"]]["head"]=$v;
		}
		foreach ($data2 as $k=>$v)
		{
			$d[$v["tn_nmkk_net"]]["data"][$v["tn_tmkk_net"]]["head"]=$v;
		}
		foreach ($data1 as $k=>$v)
		{
			$d[$v["tn_nmkk_net"]]["data"][$v["tn_tmkk_net"]]["data"][$v["id_net"]]["head"]=$v;
		}
		foreach ($data0 as $k=>$v)
		{
			$d[$v["tn_nmkk_net"]]["data"][$v["tn_tmkk_net"]]["data"][$v["id_net"]]["data"][$v["description"]]["head"]=$v;
		}
		isset($d)?$smarty->assign("d", $d):null;
                //print_r($d);
}
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=rtrim(file_get_contents('sql/list_mkk_all.sql'));
$sql=stritr($sql,$params);
$list_mkk_all = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_mkk_all', $list_mkk_all);
$sql=rtrim(file_get_contents('sql/calendar_years.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_years', $data);
$sql=rtrim(file_get_contents('sql/calendar_months.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_months', $data);
$sql=rtrim(file_get_contents('sql/list_rmkk.sql'));
$sql=stritr($sql,$params);
$list_rmkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_rmkk', $list_rmkk);
$sql=rtrim(file_get_contents('sql/list_mkk.sql'));
$sql=stritr($sql,$params);
$list_mkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_mkk', $list_mkk);
$sql=rtrim(file_get_contents('sql/nets.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);
$sql = rtrim(file_get_contents('sql/emp_exp_spd_list.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('spd_list', $data);
/*
$sql=rtrim(file_get_contents('sql/groups.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('groups', $data);
*/
$sql=rtrim(file_get_contents('sql/statya_list.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach($data as $k=>$v)
{
    if ($v["parent"]!=0) $ds[$v["parent"]]["data"][$v["id"]]=$v["cost_item"];
    else $ds[$v["id"]]["cost_item"]=$v["cost_item"];
}
$smarty->assign('statya_list', $ds);

$smarty->display('kk_start.html');
$smarty->display('media_plan.html');
$smarty->display('kk_end.html');
