<?php
if (isset($_REQUEST["save"]))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array(
		'id'=>get_new_id(),
		'dt'=>OraDate2MDBDate($_REQUEST["dt"]),
		'ag_id'=>$_REQUEST['ag_id'],
		'rep_id'=>$_REQUEST['rep_id'],
		'freq_id'=>$_REQUEST['freq_id']
	);
	Table_Update("merch_report_cal",$keys,$keys);
}
else
if (isset($_REQUEST["del"]))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array(
		'dt'=>OraDate2MDBDate($_REQUEST["dt"]),
		'ag_id'=>$_REQUEST['ag_id'],
		'rep_id'=>$_REQUEST['rep_id'],
		'freq_id'=>$_REQUEST['freq_id']
	);
	Table_Update("merch_report_cal",$keys,null);
}
else
if (isset($_REQUEST["save_d"]))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array('parent'=>$_REQUEST['parent'],$_REQUEST['field']=>$_REQUEST['val']);
	if ($_REQUEST["del"]==1)
	{
		$vals = null;
	}
	else
	{
		$vals = $keys;
	}
	Table_Update("merch_report_cal_".$_REQUEST["type"],$keys,$vals);
}
else
if (isset($_REQUEST["show"]))
{
	//print_r($_REQUEST);
	$sql=rtrim(file_get_contents('sql/merch_report_cal_'.$_REQUEST['type'].'.sql'));
	$p = array(":id"=>$_REQUEST["id"]);
	$sql=stritr($sql,$p);
	$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('d', $d);
	$smarty->display('merch_report_cal_d.html');
}
else
if (isset($_REQUEST["fill_reminders"]))
{
	$sql = rtrim(file_get_contents('sql/merch_report_cal_fill_reminders.sql'));
	$p = array(":dt"=>"'".$_REQUEST["dt"]."'");
	$sql=stritr($sql,$p);
	//echo $sql;
	$db->query($sql);
	echo "Расчет окончен";
}
else
{
	$sql = rtrim(file_get_contents('sql/merch_report_cal.sql'));
	$p = array(":dt"=>"'".$_REQUEST["month_list"]."'");
	$sql=stritr($sql,$p);
	$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
/*
	foreach ($r as $k=>$v)
	{
		$d[$v["ag_id"]]["head"]["ag_name"]=$v["ag_name"];
		$d[$v["ag_id"]]["data"][$v["rep_id"]]["rep_name"]=$v["rep_name"];
		$d[$v["ag_id"]]["data"][$v["rep_id"]]["freq_id"]=$v["freq_id"];
	}
	isset($d) ? $smarty->assign('d', $d) : null;
*/
	$smarty->assign('d', $r);
	$sql = rtrim(file_get_contents('sql/month_list.sql'));
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('month_list', $res);
	$sql=rtrim(file_get_contents('sql/merch_report_cal_freq.sql'));
	$f = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('freq', $f);
	$sql=rtrim(file_get_contents('sql/routes_agents.sql'));
	$routes_agents = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('routes_agents', $routes_agents);
	$sql=rtrim(file_get_contents('sql/merch_report_cal_rep.sql'));
	$merch_report_cal_rep = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('merch_report_cal_rep', $merch_report_cal_rep);
	$smarty->display('merch_report_cal.html');
}
?>