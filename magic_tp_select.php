<?php
//audit("вошел в список сетей");
//ses_req();
if (isset($_REQUEST["save"]))
{
	$table_name = "magic_tp_select";
	if (isset($_REQUEST["selected_changed"]))
	{
		foreach ($_REQUEST["selected_changed"] as $key => $val)
		{
			if ($val!=null)
			{
				if (((Bool2Int($val)==1)&&($_REQUEST["jan_plan"][$key]>=3000)&&($_REQUEST["jan_plan"][$key]>$_REQUEST["december"][$key]))||(Bool2Int($val)==0))
				{
					$keys = array('KOD_TP'=>$key);
					$values = array('selected'=>Bool2Int($val));
					Table_Update ($table_name, $keys, $values);
				}
			}
		}
	}
	if (isset($_REQUEST["contact_lpr"]))
	{
		foreach ($_REQUEST["contact_lpr"] as $key => $val)
		{
			$keys = array('KOD_TP'=>$key);
			$values = array('contact_lpr'=>$val);
			Table_Update ($table_name, $keys, $values);
		}
	}
	if (isset($_REQUEST["jan_plan"]))
	{
		$er_tp = array();
		foreach ($_REQUEST["jan_plan"] as $key => $val)
		{
			//«ПЛАН ЯНВАРЬ»>=3000 И «ПЛАН ЯНВАРЬ»> «Минимальный план...».
			if (!(($_REQUEST["jan_plan"][$key]>=3000)&&($_REQUEST["jan_plan"][$key]>$_REQUEST["december"][$key])))
			{
				$er_tp[$key]=$key;
			}
			else
			{
				$keys = array('KOD_TP'=>$key);
				$values = array('jan_plan'=>str_replace(",", ".", $val));
				Table_Update ($table_name, $keys, $values);
			}
		}
		$smarty->assign('er_tp', $er_tp);
	}
}

$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn);
$sql=rtrim(file_get_contents('sql/magic_tp_select.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp', $tp);

$sql_total=rtrim(file_get_contents('sql/magic_tp_select_total.sql'));
$sql_total=stritr($sql_total,$params);
$tp_total = $db->getAll($sql_total, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp_total', $tp_total);

$smarty->display('magic_tp_select.html');
?>