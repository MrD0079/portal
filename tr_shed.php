<?php

audit("открыл график обучения за ".$_REQUEST["month_list"],"tr");

InitRequestVar("tr_flt",1);

//ses_req();

$p=array();

$p[':sd'] = "'".$_REQUEST["month_list"]."'";
$p[":tn"] = $tn;
$p[':tr_flt'] = $_REQUEST["tr_flt"];

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$sql = rtrim(file_get_contents('sql/dates_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dates_list', $res);

$sql = rtrim(file_get_contents('sql/tr_shed_weeks.sql'));
$sql=stritr($sql,$p);
$month_plan_weeks = $db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);

foreach ($month_plan_weeks as $val)
{
	$sql = rtrim(file_get_contents('sql/tr_shed_week_days.sql'));
	$p[':week'] = $val;
	$sql=stritr($sql,$p);
	$month_plan_week_days = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	for ($i=1;$i<=7;$i++)
	{
		$calendar[$val][$i]='';
	}
	foreach ($month_plan_week_days as $val1)
	{
		$calendar[$val][$val1["dw"]]=$val1;
	}
	$smarty->assign('calendar', $calendar);
}

$sql = rtrim(file_get_contents('sql/tr_shed_week_days_list.sql'));
$week_days_list = $db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
$smarty->assign('week_days_list', $week_days_list);

$sql = rtrim(file_get_contents('sql/tr_shed.sql'));
$sql=stritr($sql,$p);
$tr_shed = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($tr_shed as $k=>$v)
{
	$d[$v["dt_start_t"]]['data'][$v["id"]]["head"]=$v;
	$d[$v["dt_start_t"]]['data'][$v["id"]]["data"][$v["st_tn"]]=$v;
}


//print_r($d);

isset($d) ? $smarty->assign('tr_shed', $d) : null;

$smarty->display('tr_shed.html');

?>