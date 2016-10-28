<?
InitRequestVar("calendar_years",0);
if (isset($_REQUEST["generate"]))
{
	$sql=rtrim(file_get_contents('sql/bu_distr.sql'));
	$sqlt=rtrim(file_get_contents('sql/bu_distr_t.sql'));
	$params=array(
		':y'=>$_REQUEST["calendar_years"],
	);
	$sql=stritr($sql,$params);
	$sqlt=stritr($sqlt,$params);
	//echo $sql;
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$datat = $db->getAll($sqlt, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($datat as $k=>$v)
	{
		$d[$v["id"]]["total"] = $v;
	}
	foreach ($data as $k=>$v)
	{
		$d[$v["id"]]["detail"][$v["my"]] = $v;
	}
	//print_r($d);
	isset($d)?$smarty->assign('d', $d):null;
	$smarty->assign('listm', $db->getAssoc("select distinct my,mt from calendar order by my", null, null, null, MDB2_FETCHMODE_ASSOC));
}
$sql=rtrim(file_get_contents('sql/calendar_years.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_years', $data);
$smarty->display('bu_distr.html');
?>