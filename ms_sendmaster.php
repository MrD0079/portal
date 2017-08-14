<?php

audit("открыл мастер рассылок М-Сервис","ms_sendmaster");

$sql = rtrim(file_get_contents('sql/ms_sendmaster.sql'));
$rb = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$sqll = rtrim(file_get_contents('sql/ms_sendmaster_logins_list.sql'));
$sqld = rtrim(file_get_contents('sql/ms_sendmaster_days.sql'));
foreach ($rb as $k=>$v)
{
	$p=array(":parent"=>$v['id']);
	$sqld_=stritr($sqld,$p);
	$rb[$k]['days'] = $db->getAll($sqld_, null, null, null, MDB2_FETCHMODE_ASSOC);
	if ($v['ag_id'])
	{
		$p=array(":ag"=>$v['ag_id']);
		$sqll_=stritr($sqll,$p);
		$rb[$k]['login_list'] = $db->getAll($sqll_, null, null, null, MDB2_FETCHMODE_ASSOC);
	}
}
$smarty->assign('list', $rb);


$sql = rtrim(file_get_contents('sql/calendar_week_days.sql'));
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('week_days', $x);

$sql = rtrim(file_get_contents('sql/routes_agents.sql'));
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_ag', $x);

$sql = rtrim(file_get_contents('sql/ms_sendmaster_rep.sql'));
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_rep', $x);

$smarty->display('ms_sendmaster.html');

?>