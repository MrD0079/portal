<?php
InitRequestVar("dates_list1",$_REQUEST["dates_list"]);
InitRequestVar("dates_list2",$_REQUEST["dates_list"]);
InitRequestVar("select_route_numb",0);
InitRequestVar("svms_list",0);
InitRequestVar("head_agents");
$sql = rtrim(file_get_contents('sql/dates_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dates_list', $res);
$sql=rtrim(file_get_contents('sql/svms_list.sql'));
$p = array(":tn"=>$tn,':dpt_id'=>$_SESSION['dpt_id']);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('svms_list', $data);
$sql = rtrim(file_get_contents('sql/report_total_new_routes_head.sql'));
$p=array(":tn"=>$tn,":sd"=>"'".$_REQUEST["dates_list1"]."'",":ed"=>"'".$_REQUEST["dates_list2"]."'");
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_head', $res);
$sql = rtrim(file_get_contents('sql/routes_agents.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_head_agents', $res);
if (is_array($_REQUEST["head_agents"]))
{
	$ha=join(array_keys($_REQUEST["head_agents"]),",");
}
else
{
	$a1=array();
	foreach($res as $k=>$v)
	{
		$a1[$v["id"]]=$v["id"];
	}
	$ha=join(array_keys($a1),",");
}
if (isset($_REQUEST["select"]))
{
	$p=array(
		":ha"=>$ha,
		":tn"=>$tn,
		":select_route_numb"=>$_REQUEST["select_route_numb"],
		":svms_list"=>$_REQUEST["svms_list"],
		":sd"=>"'".$_REQUEST["dates_list1"]."'",
		":ed"=>"'".$_REQUEST["dates_list2"]."'",
		);

	$sql = rtrim(file_get_contents('sql/msreportbyvisits.sql'));
	$sql=stritr($sql,$p);
	//echo $sql;
	//exit;
	$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('d', $d);
	$sql = rtrim(file_get_contents('sql/msreportbyvisitst.sql'));
	$sql=stritr($sql,$p);
	//echo $sql;
	$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('t', $res);
}
$smarty->display('msreportbyvisits.html');
?>