<?php
if (isset($_REQUEST["save"]))
{
	
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array('h_url'=>$_REQUEST['id']);
	$vals = array($_REQUEST['field']=>$_REQUEST['val']);
	Table_Update('a14tost', $keys,$vals);
}
else
{
	InitRequestVar("ok_photo",1);
	InitRequestVar("ok_visit",1);
	InitRequestVar("eta_list",$_SESSION["h_eta"]);
	InitRequestVar("dt",$now);
	$params=array(
		':dpt_id' => $_SESSION["dpt_id"],
		':tn'=>$tn,
		':ok_photo' => $_REQUEST["ok_photo"],
		':ok_visit' => $_REQUEST["ok_visit"],
		':eta_list' => "'".$_REQUEST["eta_list"]."'",
		':dt' => "'".$_REQUEST["dt"]."'",
	);
	$sql = rtrim(file_get_contents('sql/a14to_eta_list.sql'));
	$sql=stritr($sql,$params);
	$eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('eta_list', $eta_list);
	if (isset($_REQUEST['generate']))
	{
		$sql=rtrim(file_get_contents('sql/a14to_report.sql'));
		$sql=stritr($sql,$params);
		$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		//echo $sql;
		foreach($d as $k=>$v)
		{
			$sql=rtrim(file_get_contents('sql/a14to_report_photos.sql'));
			$params[':tp_kod']=$v['tp_kod_key'];
			$sql=stritr($sql,$params);
			//echo $sql;
			$d[$k]['photos'] = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		}
		$smarty->assign('d', $d);
		//print_r($d);
		$sql=rtrim(file_get_contents('sql/a14to_report_total.sql'));
		$sql=stritr($sql,$params);
		$t = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('t', $t);
		$sql=rtrim(file_get_contents('sql/a14to_report_total_perc.sql'));
		$sql=stritr($sql,$params);
		$perc_ts = $db->getOne($sql);
		$smarty->assign('perc_ts', $perc_ts);
	}
	$smarty->display('a14to_report.html');
}
?>