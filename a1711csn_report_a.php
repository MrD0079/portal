<?php
include "act_report_a_1.php";
if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["data"]))
	{
            ses_req();
		foreach($_REQUEST["data"] as $k=>$v)
		{
			$keys = array('net_kod'=>$k);
			isset($v["bonus_dt1"]) && $v["bonus_dt1"]!=null ? $v["bonus_dt1"]=OraDate2MDBDate($v["bonus_dt1"]) : $v = null;
			Table_Update ($_REQUEST['act']."_select", $keys, $v);
		}
	}
	if (isset($_REQUEST["ok_db"]))
	{
		$keys = array('tn'=>$tn,'m'=>$_REQUEST['month'],'act'=>$_REQUEST['act']);
		Table_Update ('act_ok', $keys, null);
		$keys = array('db_tn'=>$tn,'m'=>$_REQUEST['month'],'act'=>$_REQUEST['act']);
		Table_Update ('act_svodn', $keys, null);
		if ($_REQUEST["ok_db"]==1)
		{
			$params1=$params;
			$params1[':act']="'".$_REQUEST['act']."'";
			$sql=rtrim(file_get_contents("sql/".$_REQUEST['act']."_report_a_svod.sql"));
			$sql=stritr($sql,$params1);
			$x = $db->query($sql);
		}
	}
}
include "act_report_a_2.php";
include "act_report_a_3.php";
?>