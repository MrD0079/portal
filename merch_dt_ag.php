<?
if (isset($_REQUEST['save']))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array('dt'=>OraDate2MDBDate($_REQUEST['dt']),'ag_id'=>$_REQUEST['ag']);
	$vals = array($_REQUEST['field']=>$_REQUEST['val'],'lu_fio'=>$fio);
	Table_Update('merch_dt_ag', $keys,$vals);
}
else
{
	InitRequestVar("sd",$_SESSION["month_list"]);
	$p=array(':sd'=>"'".$_REQUEST["sd"]."'",":dpt_id" => $_SESSION["dpt_id"],':tn'=>$tn);
	$sql = rtrim(file_get_contents('sql/month_list.sql'));
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('month_list', $res);
	$sql = rtrim(file_get_contents('sql/merch_dt_ag.sql'));
	$sql=stritr($sql,$p);
	$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('tbl', $x);
	$smarty->display('merch_dt_ag.html');
}
?>