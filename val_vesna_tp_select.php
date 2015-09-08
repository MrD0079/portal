<?php
//audit("вошел в список сетей");
//ses_req();
if (isset($_REQUEST["save"]))
{
	$table_name = "val_vesna_tp_select";
	if (isset($_REQUEST["selected_changed"]))
	{
		foreach ($_REQUEST["selected_changed"] as $key => $val)
		{
			if ($val!=null)
			{
				$keys = array('tp_kod'=>$key,'m'=>$_REQUEST['month']);
				$values = array('selected'=>$val);
				Table_Update ($table_name, $keys, $values);
			}
		}
	}
	if (isset($_REQUEST["contact_lpr"]))
	{
		foreach ($_REQUEST["contact_lpr"] as $key => $val)
		{
				$keys = array('tp_kod'=>$key,'m'=>$_REQUEST['month']);
				$values = array('contact_lpr'=>$val);
			Table_Update ($table_name, $keys, $values);
		}
	}
}
$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn, ':month'=>$_REQUEST['month']);

$sql=rtrim(file_get_contents('sql/val_vesna_tp_select_'.$_REQUEST['month'].'.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp', $tp);


//echo $sql;

//print_r($tp);

$sql_total=rtrim(file_get_contents('sql/val_vesna_tp_select_total_'.$_REQUEST['month'].'.sql'));
$sql_total=stritr($sql_total,$params);
$tp_total = $db->getRow($sql_total, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp_total', $tp_total);

$smarty->assign('m_cur', get_month_name($_REQUEST['month']));
$smarty->assign('m_prev', get_month_name($_REQUEST['month']-1));

$smarty->display('val_vesna_tp_select.html');
?>