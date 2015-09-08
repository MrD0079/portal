<?php
//audit("вошел в список сетей");
//ses_req();
if (isset($_REQUEST["save"]))
{
	$table_name = "a1404bum_tp_select";
	if (isset($_REQUEST["selected_changed"]))
	{
		foreach ($_REQUEST["selected_changed"] as $key => $val)
		{
			if ($val!=null)
			{
				$keys = array('tp_kod'=>$key);
				($val==1)?$values=$keys:$values=null;
				Table_Update ($table_name, $keys, $values);
			}
		}
	}
	if (isset($_REQUEST["contact_lpr"]))
	{
		foreach ($_REQUEST["contact_lpr"] as $key => $val)
		{
				$keys = array('tp_kod'=>$key);
				$values = array('contact_lpr'=>$val);
			Table_Update ($table_name, $keys, $values);
		}
	}
}
$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn);
$sql=rtrim(file_get_contents('sql/a1404bum_tp_select.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp', $tp);

$smarty->display('a1404bum_tp_select.html');
?>