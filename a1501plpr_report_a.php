<?php

include "act_report_a_1.php";

if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["data"]))
	{
		foreach($_REQUEST["data"] as $k=>$v)
		{
			$keys = array('tp_kod'=>$k);
			isset($v["bonus_dt1"]) ? $v["bonus_dt1"]=OraDate2MDBDate($v["bonus_dt1"]) : null;
			Table_Update ($_REQUEST['act'].'_tp_select', $keys, $v);
		}
	}
	if (isset($_REQUEST["data_files"]))
	{
		foreach($_REQUEST["data_files"] as $k=>$v)
		{
			$keys = array('id'=>$k);
			Table_Update ($_REQUEST['act'].'_files', $keys, $v);
		}
	}
	if (isset($_REQUEST["ok_db"]))
	{
		$keys = array('tn'=>$tn,'m'=>$actParams['my'],'act'=>$_REQUEST['act']);

		if ($_REQUEST["ok_db"]==1)
		{
			Table_Update ('act_ok', $keys, $keys);
		}
		else
		{
			Table_Update ('act_ok', $keys, null);
		}
		$keys = array('db_tn'=>$tn,'m'=>$actParams['my'],'dpt_id' => $_SESSION["dpt_id"],'act'=>$_REQUEST['act']);
		Table_Update ('act_svod', $keys, null);
		Table_Update ('act_svodt', $keys, null);

		if ($_REQUEST["ok_db"]==1)
		{
			$params1=$params;
			$params1[':act']="'".$_REQUEST['act']."'";
			$params1[':ok_bonus']=2;
			$sql=rtrim(file_get_contents("sql/".$_REQUEST['act']."_report_a_svod.sql"));
			$sql=stritr($sql,$params1);
			$x = $db->query($sql);
			$sql=rtrim(file_get_contents("sql/".$_REQUEST['act']."_report_a_svodt.sql"));
			$sql=stritr($sql,$params1);
			$x = $db->query($sql);
		}
	}
}

if (isset($_REQUEST["generate"]))
{

include "act_report_a_2.php";

$sql=rtrim(file_get_contents('sql/'.$_REQUEST['act'].'_report_a_photo_files.sql'));
$sql=stritr($sql,$params);
$listf = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

if (isset($list)&&isset($listf)&&isset($d))
{
	foreach ($d as $k=>$v)
	{
		foreach ($listf as $k1=>$v1)
		{
			if ($v1["tp_kod"]==$v["tp_kod"])
			{
			$list[$k]["files"][$v1["id"]]=$v1["fn"];
			}
		}
	}
}
$smarty->assign("list", $list);

}

include "act_report_a_3.php";

?>