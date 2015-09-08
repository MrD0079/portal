<?php

audit("открыл w4u_report","w4u");


InitRequestVar("w4u_report_page","eta");
InitRequestVar("w4u_report_best","17");
InitRequestVar("ver","");
InitRequestVar("q",'01.01.2013');
$ver=$_REQUEST['ver'];

$sql = rtrim(file_get_contents('sql/w4u_report'.$ver.'_select_q_list.sql'));
$w4u_report_q_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('w4u_report_q_list', $w4u_report_q_list);


$params=array(
	':tn'=>$tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':q'=>"'".$_REQUEST['q']."'"
);


if (isset($_REQUEST["generate"]))
{
	$sql = rtrim(file_get_contents('sql/w4u_report'.$ver.'_table_'.$_REQUEST["w4u_report_page"].'_cells_m.sql'));
	$sql=stritr($sql,$params);
	$cells_m = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

	$sql = rtrim(file_get_contents('sql/w4u_report'.$ver.'_table_'.$_REQUEST["w4u_report_page"].'_cells_q.sql'));
	$sql=stritr($sql,$params);
	$cells_q = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

	$sql = rtrim(file_get_contents('sql/w4u_report'.$ver.'_table_'.$_REQUEST["w4u_report_page"].'_cells_y.sql'));
	$sql=stritr($sql,$params);
	$cells_y = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

	$sql = rtrim(file_get_contents('sql/w4u_report'.$ver.'_table_cols.sql'));
	$sql=stritr($sql,$params);
	$cols = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

	foreach ($cols as $k=>$v)
	{
		$d['cols'][$v['y']][$v['q']][$v['m']]=$v['mt'];
	}

	foreach ($cells_q as $k=>$v)
	{
		$d['cells'][$v['fio']]['data'][$v['y']]['data'][$v['q']]['fact_ball']=$v['fact_ball'];
		$d['cells'][$v['fio']]['data'][$v['y']]['data'][$v['q']]['bad_akb']=$v['bad_akb'];
		isset($v['qd_t']) ? $d['cells'][$v['fio']]['data'][$v['y']]['data'][$v['q']]['qd']=$v['qd_t'] : null;
	}

	foreach ($cells_m as $k=>$v)
	{
		$d['cells'][$v['fio']]['data'][$v['y']]['data'][$v['q']]['data'][$v['m']]['fact_ball']=$v['fact_ball'];
		$d['cells'][$v['fio']]['data'][$v['y']]['data'][$v['q']]['data'][$v['m']]['bad_akb']=$v['bad_akb'];
		$d['cells'][$v['fio']]['head']=$v['parent_fio'];
	}

	foreach ($cells_y as $k=>$v)
	{
		$d['cells'][$v['fio']]['data'][$v['y']]['total']=$v['fact_ball'];
	}

	?><table><tr><td><pre><?
	//print_r($d);
	?></td></tr></table></pre><?
	
	isset($d) ? $smarty->assign('d', $d):null;
}

$smarty->display('w4u_report.html');

?>