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
	$_REQUEST['field']=='datar'?$_REQUEST['val']=OraDate2MDBDate($_REQUEST['val']):null;
	$vals = array($_REQUEST['field']=>$_REQUEST['val']);
	Table_Update('dm_fil_stat_month', $keys,$vals);
}
else
if (isset($_REQUEST['del_file']))
{
	unlink("files/".$_REQUEST['fn']);
	$keys = array('id'=>$_REQUEST['id']);
	Table_Update('dm_fil_stat_files', $keys,null);
}
else
if (isset($_REQUEST['send_file']))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$_FILES = recursive_iconv ('UTF-8', 'Windows-1251', $_FILES);
	foreach ($_FILES as $k=>$v)
	{
		if
		(
			is_uploaded_file($v['tmp_name'])
		)
		{
			$a=pathinfo($v['name']);
			$id=get_new_file_id();
			//$fn=$id.'_'.translit($v["name"]).'.'.$a['extension'];
			$fn=$id.'_'.translit($v["name"]);
			$keys = array('dt'=>OraDate2MDBDate($_REQUEST['dt']),'tn'=>$_REQUEST['tn'],'bud_id'=>$_REQUEST['bud_id'],'fn'=>$fn,'id'=>$id);
			Table_Update('dm_fil_stat_files', $keys,$keys);
			move_uploaded_file($v['tmp_name'], 'files/'.$fn);
			echo '<div style="display:inline" id="fn'.$id.'">
			<br><a href="javascript:void(0);" onclick="del_file('.$id.',\''.$fn.'\')">[x]</a> <a target=_blank href="files/'.$fn.'">'.$fn.'</a>
			</div>';
		}
		else
		{
			echo 'Ошибка загрузки файла';
		}
	}
}
else
{
	InitRequestVar("fils",0);
	InitRequestVar("dm",0);
	InitRequestVar("bud_id",0);
	
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
		$d['columns'][$v['data8']]['dw']=$v['dw'];
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
		$d['data'][$v['tn'].'.'.$v['bud_id']]['datar']=$v['datar'];
		$d['data'][$v['tn'].'.'.$v['bud_id']]['doc_delta']=$v['doc_delta'];
		$d['data'][$v['tn'].'.'.$v['bud_id']]['sum_delta']=$v['sum_delta'];
		$d['data'][$v['tn'].'.'.$v['bud_id']]['doc_perc']=$v['doc_perc'];
		$d['data'][$v['tn'].'.'.$v['bud_id']]['sum_perc']=$v['sum_perc'];
		//$d['data'][$v['tn'].'.'.$v['bud_id']]['fn']=$v['fn'];
	}
	$sql = rtrim(file_get_contents('sql/dm_fil_stat_files.sql'));
	$sql=stritr($sql,$p);
	//echo $sql;
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	//print_r($data);
	//$d = [];
	foreach ($data as $k => $v)
	{
		$d['data'][$v['tn'].'.'.$v['bud_id']]['files'][$v['id']]=$v['fn'];
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
	