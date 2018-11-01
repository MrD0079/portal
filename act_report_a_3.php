<?php
if (isset($_REQUEST["generate"]))
{
	$sql=rtrim(file_get_contents("sql/".$_REQUEST['act']."_report_a_itogi.sql"));
	$sql=stritr($sql,$params);
	$list = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign("itogi", $list);
	$sql=rtrim(file_get_contents("sql/act_report_a_itogi_files.sql"));
	$sql=stritr($sql,$params);
	$list = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign("itogi_files", $list);
	$d1=array();
	$sql=rtrim(file_get_contents('sql/act_files.sql'));
	$sql=stritr($sql,$params);
	//echo $sql;
	$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	if (isset($d))
	{
		foreach ($d as $k=>$v)
		{
			$d1[$v["tn"]]["data"][$v["id"]]=$v;
		}
	}
	$sql=rtrim(file_get_contents('sql/act_files_total.sql'));
	$sql=stritr($sql,$params);
	$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	if (isset($d))
	{
		foreach ($d as $k=>$v)
		{
			$d1[$v["tn"]]["data_total"]=$v;
		}
	}
	if (isset($d1)){$smarty->assign('file_list', $d1);}

	$sql=rtrim(file_get_contents('sql/act_files_total_total.sql'));
	$sql=stritr($sql,$params);
	$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('file_list_total', $d);

	$sql=rtrim(file_get_contents("sql/act_report_a_db.sql"));
	isset($paramsN)?$sql=stritr($sql,$paramsN):$sql=stritr($sql,$params);
	$list = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign("list_db", $list);

	$sql=rtrim(file_get_contents("sql/act_report_a_ok_chief.sql"));
	isset($paramsN)?$sql=stritr($sql,$paramsN):$sql=stritr($sql,$params);
	$x = $db->getOne($sql);
	$smarty->assign("ok_chief", $x);

	$sql=rtrim(file_get_contents("sql/act_report_a_ok_chief.sql"));
	isset($paramsN)?$sql=stritr($sql,$paramsN):$sql=stritr($sql,$params);
	$x = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign("ok_chief_4ts", $x);
}


$smarty->assign('m_cur', get_month_name($actParams['my']));
$smarty->display($_REQUEST['act'].'_report_a.html');
?>