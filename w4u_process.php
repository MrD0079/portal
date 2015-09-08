<?php

audit("открыл w4u_process","w4u");


InitRequestVar("w4u_process_ts_list",0);
InitRequestVar("w4u_process_tm_list",0);
InitRequestVar("w4u_process_rm_list",0);
InitRequestVar("page","ts");
InitRequestVar("ver","");

$ver=$_REQUEST['ver'];

$params=array(
	':tn'=>$tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':w4u_process_ts_list' => $_REQUEST["w4u_process_ts_list"],
	':w4u_process_tm_list' => $_REQUEST["w4u_process_tm_list"],
	':w4u_process_rm_list' => $_REQUEST["w4u_process_rm_list"],
	':dt'=>"'".$_REQUEST['dt']."'"
);

$sql = rtrim(file_get_contents('sql/w4u_process'.$ver.'_get_base_month.sql'));
$sql=stritr($sql,$params);
$bm = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('m_cur', get_month_name($_REQUEST['m']));
$smarty->assign('y_cur', $_REQUEST['y']);
$smarty->assign('m_bas', get_month_name($bm['m']));
$smarty->assign('y_bas', $bm['y']);

$sql = rtrim(file_get_contents('sql/w4u_process_select_ts_list.sql'));
$sql=stritr($sql,$params);
$w4u_process_ts_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('w4u_process_ts_list', $w4u_process_ts_list);

$sql = rtrim(file_get_contents('sql/w4u_process_select_tm_list.sql'));
$sql=stritr($sql,$params);
$w4u_process_tm_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('w4u_process_tm_list', $w4u_process_tm_list);

$sql = rtrim(file_get_contents('sql/w4u_process_select_rm_list.sql'));
$sql=stritr($sql,$params);
$w4u_process_rm_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('w4u_process_rm_list', $w4u_process_rm_list);

if (isset($_REQUEST["generate"]))
{
	$sql = rtrim(file_get_contents('sql/w4u_process'.$ver.'_table_'.$_REQUEST["page"].'_cells.sql'));
	$sql=stritr($sql,$params);
	$cells = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

	
	$sql = rtrim(file_get_contents('sql/w4u_process'.$ver.'_table_'.$_REQUEST["page"].'_rows_total.sql'));
	$sql=stritr($sql,$params);
	$trows = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

//echo $sql;
//exit;
	
	$sql = rtrim(file_get_contents('sql/w4u_process'.$ver.'_table_'.$_REQUEST["page"].'_cols.sql'));
	$sql=stritr($sql,$params);
	$cols = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	
	$sql = rtrim(file_get_contents('sql/w4u_process'.$ver.'_table_'.$_REQUEST["page"].'_cols_total.sql'));
	$sql=stritr($sql,$params);
	$tcols = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

	$sql = rtrim(file_get_contents('sql/w4u_process'.$ver.'_table_'.$_REQUEST["page"].'_total.sql'));
	$sql=stritr($sql,$params);
	$tt = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

	/*$d['total']['m_qtytt']=$tt['m_qtytt'];
	$d['total']['bm_qtytt']=$tt['bm_qtytt'];
	$d['total']['perc']=$tt['perc'];
	$d['total']['bperc']=$tt['bperc'];*/
	$d['total']['fact_ball']=$tt['fact_ball'];

	if (count($cols)>0)
	{
	foreach ($cols as $k=>$v)
	{
		$d['cols'][$v['tn']]['head']['fio']=$v['fio'];
		$d['cols'][$v['tn']]['head']['akb']=$v['akb'];
		$d['cols'][$v['tn']]['head']['akbprev']=$v['akbprev'];
	}
	}

	foreach ($trows as $k=>$v)
	{
		/*$d['cols'][$v['tn']]['total']['m_qtytt']=$v['m_qtytt'];
		$d['cols'][$v['tn']]['total']['bm_qtytt']=$v['bm_qtytt'];
		$d['cols'][$v['tn']]['total']['perc']=$v['perc'];
		$d['cols'][$v['tn']]['total']['bperc']=$v['bperc'];*/
		$d['cols'][$v['tn']]['total']['fact_ball']=$v['fact_ball'];
	}

	foreach ($cells as $k=>$v)
	{
		$d['cells'][$v['cat']][$v['prod_id']]['head']['product_name_sw']=$v['product_name_sw'];
		isset($v['product_weight'])?$d['cells'][$v['cat']][$v['prod_id']]['head']['product_weight']=$v['product_weight']:null;
		$d['cells'][$v['cat']][$v['prod_id']]['head']['ball']=$v['ball'];
		$d['cells'][$v['cat']][$v['prod_id']]['head']['min_por']=$v['min_por'];
		$d['cells'][$v['cat']][$v['prod_id']]['data'][$v['tn']]['tn']=$v['tn'];
		$d['cells'][$v['cat']][$v['prod_id']]['data'][$v['tn']]['m_qtytt']=$v['m_qtytt'];
		$d['cells'][$v['cat']][$v['prod_id']]['data'][$v['tn']]['bm_qtytt']=$v['bm_qtytt'];
		$d['cells'][$v['cat']][$v['prod_id']]['data'][$v['tn']]['perc']=$v['perc'];
		$d['cells'][$v['cat']][$v['prod_id']]['data'][$v['tn']]['bperc']=$v['bperc'];
		$d['cells'][$v['cat']][$v['prod_id']]['data'][$v['tn']]['fact_ball']=$v['fact_ball'];
	}

	foreach ($tcols as $k=>$v)
	{
		$d['cells'][$v['cat']][$v['prod_id']]['total']['m_qtytt']=$v['m_qtytt'];
		$d['cells'][$v['cat']][$v['prod_id']]['total']['bm_qtytt']=$v['bm_qtytt'];
		$d['cells'][$v['cat']][$v['prod_id']]['total']['perc']=$v['perc'];
		$d['cells'][$v['cat']][$v['prod_id']]['total']['bperc']=$v['bperc'];
		$d['cells'][$v['cat']][$v['prod_id']]['total']['fact_ball']=$v['fact_ball'];
	}

	if ($_REQUEST["page"]=='ts')
	{
	}
	else
	{
	}
	        
	?><table><tr><td><pre><?
	//print_r($d);
	?></td></tr></table></pre><?
	
	isset($d) ? $smarty->assign('d', $d):null;
}

$smarty->display('w4u_process.html');

?>