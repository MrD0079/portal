<?php
//audit("вошел в список сетей");
//ses_req();
if (isset($_REQUEST["save"]))
{
	$table_name = "a16p5net_select";
	if (isset($_REQUEST["selected_changed"]))
	{
		foreach ($_REQUEST["selected_changed"] as $key => $val)
		{
			if ($val!=null)
			{
				$keys = array('net_kod'=>$key);
				($val==1)?$values=array('lu_fio'=>$fio):$values=null;
				Table_Update ($table_name, $keys, $values);
			}
		}
	}
}
$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn);
$sql=rtrim(file_get_contents('sql/a16p5net_select.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp', $tp);
$sql=rtrim(file_get_contents('sql/a16p5net_select_total.sql'));
$sql=stritr($sql,$params);
$tp = $db->getOne($sql);
$smarty->assign('tp_total', $tp);
$smarty->display('a16p5net_select.html');
?>