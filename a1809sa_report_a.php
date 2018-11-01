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
				$sql1="
                                      SELECT COUNT (*)
                                        FROM ".$_REQUEST['act']."_action_nakl
                                       WHERE h_tp_kod_data_nakl IN (SELECT h_tp_kod_data_nakl
                                                                      FROM ".$_REQUEST['act']."
                                                                     WHERE tp_kod = (SELECT tp_kod
                                                                                       FROM ".$_REQUEST['act']."
                                                                                      WHERE h_tp_kod_data_nakl = '".$key."'))
                                         AND h_tp_kod_data_nakl <> '".$key."'
                                      ";
				$c1=$db->getOne($sql1);
				if ($c1>=2)
				{
					echo "<p>По одному клиенту за период акции может быть только не более двух акционных накладных!!!</p>";
				}
				if ($c1<2)
				{
					Table_Update ($_REQUEST['act']."_action_nakl", $keys, $vals);
				}
			}
			else
			{
				Table_Update ("a1809sa_action_nakl", $keys, null);
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
			if (($v['bonus_sum1']+$v['bonus_sum2'])>$v['max_bonus'])
			{
				echo "<p>Максимальный бонус по накладной ".$v['nakl']." - ".$v['max_bonus']." !!!</p>";
			}
			else
			{
				unset($v["max_bonus"]);
				unset($v["nakl"]);
				Table_Update ('a1809sa_action_nakl', $keys, $v);
			}
		}
	}
	if (isset($_REQUEST["del"]))
	{
		foreach ($_REQUEST["del"] as $key => $val)
		{
			$keys = array('id'=>$key);
			Table_Update ('a1809sa_action_nakl', $keys, null);
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

	}
}

$sql=rtrim(file_get_contents('sql/a1809sa_report_a_tp.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp', $tp);

if ($_REQUEST["selected_tp"]!=0)
{
$sql = rtrim(file_get_contents('sql/a1809sa_report_a_nakl.sql'));
$sql=stritr($sql,$params);
$nakl_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nakl_list', $nakl_list);
}

include "act_report_a_2.php";
include "act_report_a_3.php";

?>