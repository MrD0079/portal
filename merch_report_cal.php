<?php
if (isset($_REQUEST["save"]))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array(
		'dt'=>OraDate2MDBDate($_REQUEST["dt"]),
		'ag_id'=>$_REQUEST['ag_id'],
		'rep_id'=>$_REQUEST['rep_id']
	);
	$vals = array('freq_id'=>$_REQUEST['freq_id']);
	Table_Update("merch_report_cal",$keys,$vals);
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
	foreach ($r as $k=>$v)
	{
		$d[$v["ag_id"]]["head"]["ag_name"]=$v["ag_name"];
		$d[$v["ag_id"]]["data"][$v["rep_id"]]["rep_name"]=$v["rep_name"];
		$d[$v["ag_id"]]["data"][$v["rep_id"]]["freq_id"]=$v["freq_id"];
	}
	isset($d) ? $smarty->assign('d', $d) : null;
	$sql = rtrim(file_get_contents('sql/month_list.sql'));
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('month_list', $res);
	$sql=rtrim(file_get_contents('sql/merch_report_cal_freq.sql'));
	$f = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('freq', $f);
	$smarty->display('merch_report_cal.html');
}
?>