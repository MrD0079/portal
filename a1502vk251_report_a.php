<?php

include "act_report_a_1.php";

if (isset($_REQUEST["add"]))
{
	if (isset($_REQUEST["keys"]))
	{
		foreach ($_REQUEST["keys"] as $key => $val)
		{
			$keys = array('h_tp_kod_data_nakl'=>$key);
			isset($_REQUEST["data_s"][$key]) ? $vals = $_REQUEST["data_s"][$key] : $vals = null;
			isset($vals["bonus_dt1"]) ? $vals["bonus_dt1"]=OraDate2MDBDate($vals["bonus_dt1"]) : null;
			if ($vals["if1"]!=0)
			{
				Table_Update ($_REQUEST['act']."_action_nakl", $keys, $vals);
			}
			else
			{
				Table_Update ($_REQUEST['act']."_action_nakl", $keys, null);
			}
		}
	}
}

if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["data"]))
	{
		foreach($_REQUEST["data"] as $k=>$v)
		{
			$keys = array('id'=>$k);
			isset($v["bonus_dt1"]) ? $v["bonus_dt1"]=OraDate2MDBDate($v["bonus_dt1"]) : null;
			Table_Update ($_REQUEST['act'].'_action_nakl', $keys, $v);
				$sql1="
  SELECT CASE
            WHEN NVL (SUM (t2.bonus_sum1), 0) <=
                    CASE
                       WHEN t1.chanel_type = 1 THEN 160
                       WHEN t1.chanel_type = 2 THEN 300
                       WHEN t1.chanel_type = 3 THEN 600
                    END
            THEN
               1
         END
            bonus_ok
    FROM ".$_REQUEST['act']." t1, ".$_REQUEST['act']."_action_nakl t2
   WHERE     t1.h_tp_kod_data_nakl = t2.h_tp_kod_data_nakl
         AND tp_kod =
                (SELECT tp_kod
                   FROM ".$_REQUEST['act']."
                  WHERE h_tp_kod_data_nakl = (SELECT h_tp_kod_data_nakl
                                                FROM ".$_REQUEST['act']."_action_nakl
                                               WHERE id = ".$k."))
GROUP BY t1.chanel_type
                                      ";
				$bonus_ok=$db->getOne($sql1);
				if ($bonus_ok!=1)
				{
					$v['bonus_sum1']=0;
					Table_Update ("act_action_nakl", $keys, $v);
					echo "<p style='color:red;font-weight:bold'>Превышено ограничение по сумме бонуса на 1 ТП за период акции!!!</p>";
				}


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
	if (isset($_REQUEST["del"]))
	{
		foreach ($_REQUEST["del"] as $key => $val)
		{
			$keys = array('id'=>$key);
			Table_Update ($_REQUEST['act'].'_action_nakl', $keys, null);
		}
	}
	if (isset($_REQUEST["ok_db"]))
	{
		$keys = array('tn'=>$tn,'m'=>$_REQUEST['month'],'act'=>$_REQUEST['act']);

		if ($_REQUEST["ok_db"]==1)
		{
			Table_Update ('act_ok', $keys, $keys);
		}
		else
		{
			Table_Update ('act_ok', $keys, null);
		}
		$keys = array('db_tn'=>$tn,'m'=>$_REQUEST['month'],'dpt_id' => $_SESSION["dpt_id"],'act'=>$_REQUEST['act']);
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

$sql=rtrim(file_get_contents('sql/'.$_REQUEST['act'].'_report_a_tp.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp', $tp);

if ($_REQUEST["selected_tp"]!=0)
{
$sql = rtrim(file_get_contents('sql/'.$_REQUEST['act'].'_report_a_nakl.sql'));
$sql=stritr($sql,$params);
$nakl_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nakl_list', $nakl_list);
}

include "act_report_a_2.php";
include "act_report_a_3.php";

?>