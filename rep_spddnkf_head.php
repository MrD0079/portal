<?
InitRequestVar("month_list",$_SESSION["month_list"]);
$sql = rtrim(file_get_contents('sql/month_list.sql'));
$month_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $month_list);
if (isset($_REQUEST["save"]))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array('dt'=>OraDate2MDBDate($_REQUEST['dt']),'tn'=>$_REQUEST['tn']);
	Table_Update('rep_spddnkf_head', $keys,$keys);
	//$_REQUEST['field']=='last_month'?$_REQUEST['val']=OraDate2MDBDate($_REQUEST['val']):null;
	$vals = array($_REQUEST['field']=>$_REQUEST['val']);
	Table_Update('rep_spddnkf_head', $keys,$vals);
}
else
{
	$p = array(":month_list" => "'".$_REQUEST["month_list"]."'");
	if (isset($_REQUEST["generate"]))
	{
		$keys = array('dt'=>OraDate2MDBDate($_REQUEST["month_list"]));
		Table_Update('rep_spddnkf_dt', $keys,$keys);
	}
	$sql = rtrim(file_get_contents('sql/rep_spddnkf_head.sql'));
	$sql=stritr($sql,$p);
	$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('rep_spddnkf_head', $r);
	$sql = rtrim(file_get_contents('sql/rep_spddnkf_generate_status.sql'));
	$sql=stritr($sql,$p);
	//echo $sql;
	$r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('status', $r);
	//print_r($r);
	$smarty->display('rep_spddnkf_head.html');
}

?>