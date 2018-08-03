<?php
include "act_report_a_1.php";
if (isset($_REQUEST["save"]))
{
	
	if (isset($_REQUEST["data"]))
	{
		foreach($_REQUEST["data"] as $k=>$v)
		{
			$keys = array('h_client'=>$k);
			isset($v["bonus_dt1"]) ? $v["bonus_dt1"]=OraDate2MDBDate($v["bonus_dt1"]) : null;
			$v["bonus_dt1"]==null ? $v = null : null;
			Table_Update ($_REQUEST['act'].'_action_client', $keys, $v);
		}
	}
	if (isset($_REQUEST["ok_db"]))
	{
		$keys = array('tn'=>$tn,'m'=>$actParams['my'],'act'=>$_REQUEST['act']);

		if ($_REQUEST["ok_db"]==1)
		{
			//Table_Update ('act_ok', $keys, $keys);
		}
		else
		{
			Table_Update ('act_ok', $keys, null);
		}
		//$keys = array('db_tn'=>$tn,'m'=>$actParams['my'],'dpt_id' => $_SESSION["dpt_id"],'act'=>$_REQUEST['act']);
		//Table_Update ('act_svod', $keys, null);
		//Table_Update ('act_svodt', $keys, null);
		if ($_REQUEST["ok_db"]==1)
		{
			$sql=rtrim(file_get_contents("sql/".$_REQUEST['act']."_report_a_zay_create.sql"));
			$sql=stritr($sql,$params);
			$x = $db->query($sql);
			//echo $sql;
			$sql=rtrim(file_get_contents("sql/".$_REQUEST['act']."_report_a_zay_create_get_sup_doc.sql"));
			$sql=stritr($sql,$params);
			$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			//print_r($x);
			foreach($x as $k=>$v)
			{
				$path="files/bud_ru_zay_files/".$v["id"]."/sup_doc";
				if (!file_exists($path)) {mkdir($path,0777,true);}
				$x1 = explode("\n",$v["sup_doc"]);
				foreach($x1 as $k1=>$v1)
				{
					copy("files/".$v1,"files/bud_ru_zay_files/".$v["id"]."/sup_doc/".$v1);
				}
			}

		}
		else
		{
			$sql=rtrim(file_get_contents("sql/".$_REQUEST['act']."_report_a_zay_delete.sql"));
			$sql=stritr($sql,$params);
			$x = $db->query($sql);
			//echo $sql;
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
		$params[":h_client"]="'".$v["h_client"]."'";
		$sql1=stritr($sql,$params);
		$listt = $db->getAll($sql1, null, null, null, MDB2_FETCHMODE_ASSOC);
		$list[$k]["tp"] = $listt;
	}
	$smarty->assign("list", $list);
	//print_r($list);
}
$sql=rtrim(file_get_contents('sql/bud_ru_zay_create_fils.sql'));
$sql=stritr($sql,array(":tn"=>$tn,":dt"=>"'01.12.2015'"));
$fil = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('fil', $fil);
include "act_report_a_3.php";
?>