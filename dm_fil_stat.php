<?php
if (isset($_REQUEST['save']))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array('dt'=>OraDate2MDBDate($_REQUEST['dt']),'tn'=>$_REQUEST['tn'],'bud_id'=>$_REQUEST['bud_id']);
	$vals = array('val'=>$_REQUEST['val']);
	Table_Update('dm_fil_stat_day', $keys,$vals);
}
else
if (isset($_REQUEST['save_m']))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array('dt'=>OraDate2MDBDate($_REQUEST['dt']),'tn'=>$_REQUEST['tn'],'bud_id'=>$_REQUEST['bud_id']);
	$vals = array($_REQUEST['field']=>$_REQUEST['val']);
	Table_Update('dm_fil_stat_month', $keys,$vals);
}
else
{
	InitRequestVar("fils",0);
	InitRequestVar("dm",0);
	InitRequestVar("bud_id",0);
	//ses_req();
	$p = array(
		":tn" => $tn,
		":dt" => "'".$_REQUEST["month_list"]."'",
		":dpt_id" => $_SESSION["dpt_id"],
		":fils" => $_REQUEST["fils"],
		":dm" => $_REQUEST["dm"],
		":bud_id" => $_REQUEST["bud_id"],
	);
	$sql = rtrim(file_get_contents('sql/dm_fil_stat_day.sql'));
	$sql=stritr($sql,$p);
	//echo $sql;
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	//print_r($data);
	$d = [];
	foreach ($data as $k => $v)
	{
		$d['columns'][$v['data8']]['dm']=$v['dm'];
		$d['columns'][$v['data8']]['dwtc']=$v['dwtc'];
		$d['columns'][$v['data8']]['current_week']=$v['current_week'];
		$d['data'][$v['tn'].'.'.$v['bud_id']]['tn']=$v['tn'];
		$d['data'][$v['tn'].'.'.$v['bud_id']]['bud_id']=$v['bud_id'];
		$d['data'][$v['tn'].'.'.$v['bud_id']]['fio']=$v['fio'];
		$d['data'][$v['tn'].'.'.$v['bud_id']]['bud_name']=$v['bud_name'];
		$d['data'][$v['tn'].'.'.$v['bud_id']]['data'][$v['data8']]['val']=$v['val'];
		$d['data'][$v['tn'].'.'.$v['bud_id']]['data'][$v['data8']]['data']=$v['data'];
		$d['data'][$v['tn'].'.'.$v['bud_id']]['data'][$v['data8']]['data_t']=$v['data_t'];
	}


	$sql = rtrim(file_get_contents('sql/dm_fil_stat_month.sql'));
	$sql=stritr($sql,$p);
	//echo $sql;
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	//print_r($data);
	//$d = [];
	foreach ($data as $k => $v)
	{
		$d['data'][$v['tn'].'.'.$v['bud_id']]['doc1c']=$v['doc1c'];
		$d['data'][$v['tn'].'.'.$v['bud_id']]['sum1c']=$v['sum1c'];
		$d['data'][$v['tn'].'.'.$v['bud_id']]['docdm']=$v['docdm'];
		$d['data'][$v['tn'].'.'.$v['bud_id']]['sumdm']=$v['sumdm'];
	}
	//print_r($d);
	$smarty->assign('list', $d);
	$sql = rtrim(file_get_contents('sql/dm_list_fil.sql'));
	$sql=stritr($sql,$p);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('bud_fil', $data);
	$sql = rtrim(file_get_contents('sql/dm_list.sql'));
	$sql=stritr($sql,$p);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('bud_tn', $data);
	$sql = rtrim(file_get_contents('sql/month_list.sql'));
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('month_list', $res);
	$smarty->display('dm_fil_stat.html');
	}
	