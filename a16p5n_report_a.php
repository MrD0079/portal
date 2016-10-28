<?php
include "act_report_a_1.php";
$act = 'a16p5';
if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["data"]))
	{
		//ses_req();
		foreach($_REQUEST["data"] as $k=>$v)
		{
			$keys = array('tp_kod'=>$k);
			isset($v["bonus_dt1"]) ? $v["bonus_dt1"]=OraDate2MDBDate($v["bonus_dt1"]) : null;
			$v["bonus_dt1"]==null ? $v = null : null;
			Table_Update ($_REQUEST['act']."_nettp", $keys, $v);
		}
	}
	if (isset($_REQUEST["ok_db"]))
	{
		$keys = array('tn'=>$tn,'m'=>$_REQUEST['month'],'act'=>$act);
		if ($_REQUEST["ok_db"]==1)
		{
			$vals=array('part2'=>1);
			Table_Update ('act_ok', $keys, $vals);
		}
		else
		{
			$vals=array('part2'=>0);
			Table_Update ('act_ok', $keys, $vals);
		}
		$keys = array('db_tn'=>$tn,'m'=>$_REQUEST['month'],'dpt_id' => $_SESSION["dpt_id"],'act'=>$act);
		Table_Update ('act_svod', $keys, null);
		Table_Update ('act_svodt', $keys, null);
		if ($_REQUEST["ok_db"]==1)
		{
			$params1=$params;
			$params1[':act']="'".$act."'";
			$sql=rtrim(file_get_contents("sql/".$act."_report_a_svod.sql"));
			$sql=stritr($sql,$params1);
			$x = $db->query($sql);
			$sql=rtrim(file_get_contents("sql/".$act."_report_a_svodt.sql"));
			$sql=stritr($sql,$params1);
			$x = $db->query($sql);
		}
	}
}
include "act_report_a_2.php";
if (isset($list))
{
	//print_r($list);
	$sql=rtrim(file_get_contents("sql/".$_REQUEST['act']."_report_a_tp.sql"));
	foreach($list as $k=>$v)
	{
		$params[":h_net"]="'".$v["h_net"]."'";
		$sql1=stritr($sql,$params);
		$listt = $db->getAll($sql1, null, null, null, MDB2_FETCHMODE_ASSOC);
		$list[$k]["tp"] = $listt;
	}
	$smarty->assign("list", $list);
	//print_r($list);
}
$paramsN=$params;
$paramsN[":act"]="'".$act."'";
include "act_report_a_3.php";
?>