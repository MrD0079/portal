<?
if (isset($_REQUEST['save']))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array('dt' => OraDate2MDBDate($_REQUEST['month_list']),'dpt_id' => $_SESSION["dpt_id"],'kk'=>$_REQUEST['kk']);
	$vals = array($_REQUEST['field']=>$_REQUEST['val']);
	$_REQUEST['table']=='b'?$keys['db']=$_REQUEST['db']:null;
	$_REQUEST['table']=='f'?$keys['db']=$_REQUEST['db']:null;
	$_REQUEST['table']=='f'?$keys['fund']=$_REQUEST['fund']:null;
	$_REQUEST['table']=='ft'?$keys['fund']=$_REQUEST['fund']:null;
	Table_Update('bud_funds_limits_'.$_REQUEST['table'], $keys,$vals);
}
else
{
	$params=array(
		':month_list' => "'".$_REQUEST["month_list"]."'",
		':dpt_id' => $_SESSION["dpt_id"],
		':kk' => $_REQUEST["kk"]
	);

	$sql = rtrim(file_get_contents('sql/month_list.sql'));
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('month_list', $res);

	$sql = rtrim(file_get_contents('sql/bud_funds_limits_f_list.sql'));
	$sql=stritr($sql,$params);
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('f_list', $res);

	$sql=rtrim(file_get_contents('sql/bud_funds_limits_h.sql'));
	$sql=stritr($sql,$params);
	$x = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('h', $x);

	$sql=rtrim(file_get_contents('sql/bud_funds_limits_b.sql'));
	$sql=stritr($sql,$params);
	$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($x as $k=>$v)
	{
		$params[':db']=$v['db'];
		$sql=rtrim(file_get_contents('sql/bud_funds_limits_f.sql'));
		$sql=stritr($sql,$params);
		$x[$k]['detail'] = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	}
	$smarty->assign('b', $x);

	$sql=rtrim(file_get_contents('sql/bud_funds_limits_ft.sql'));
	$sql=stritr($sql,$params);
	$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('f', $x);

	$smarty->display('bud_funds_limits.html');
}
?>