<?php

//ses_req();

audit("открыл Реестр ДЦ","reestr_dc");

InitRequestVar("dates_list1",$_REQUEST["dates_list"]);
InitRequestVar("dates_list2",$_REQUEST["dates_list"]);
InitRequestVar("zgdp",0);
InitRequestVar("os",0);
InitRequestVar("pos",0);
InitRequestVar("goal_res",0);

$sql = rtrim(file_get_contents('sql/dates_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dates_list', $res);

$sql = rtrim(file_get_contents('sql/pos_list_reestr_dc.sql'));
//echo $sql;
$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pos_list_reestr_dc', $res);

$sql=rtrim(file_get_contents('sql/os_goal.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('os_goal', $data);

if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["data"]))
	{
		foreach ($_REQUEST["data"] as $k=>$v)
		{
			isset($v["os_lu"])?$v["os_lu"]=OraDate2MDBDate($v["os_lu"]):null;
			Table_Update ("os_head", array("id"=>$k), $v);
		}
	}
}

$params=array(
	':dpt_id' => $_SESSION["dpt_id"],
	":dates_list1"=>"'".$_REQUEST["dates_list1"]."'",
	":dates_list2"=>"'".$_REQUEST["dates_list2"]."'",
	":ok_zgdp"=>$_REQUEST["zgdp"],
	":os"=>$_REQUEST["os"],
	":pos"=>$_REQUEST["pos"],
	":goal_res"=>$_REQUEST["goal_res"]
);

$sql = rtrim(file_get_contents('sql/reestr_dc.sql'));
$sql=stritr($sql,$params);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('reestr_dc', $res);

$sql = rtrim(file_get_contents('sql/reestr_dc_total.sql'));
$sql=stritr($sql,$params);
$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('reestr_dc_total', $res);

$smarty->display('reestr_dc.html');

?>