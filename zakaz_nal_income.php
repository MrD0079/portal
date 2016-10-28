<?
if (isset($_REQUEST["save"]))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array(
		'tn'=>$_REQUEST['tn'],
		'year'=>$_REQUEST['year'],
		'month'=>$_REQUEST['month']
	);
	$_REQUEST["field"]=="remain_dt" ? $_REQUEST["val"] = OraDate2MDBDate($_REQUEST["val"]) : null;
	$vals = array($_REQUEST['field'] => $_REQUEST['val']);
	Table_Update('promo_'.$_REQUEST["table"], $keys,$vals);
}
else
{
audit("открыл zakaz_nal_report","zakaz_nal_report");
InitRequestVar("calendar_years");
InitRequestVar("plan_month");
if (isset($_REQUEST["generate"]))
{
	$params=array(
		':y'=>$_REQUEST["calendar_years"],
		":plan_month" => $_REQUEST["plan_month"],
	);
	$sql=rtrim(file_get_contents('sql/zakaz_nal_income.sql'));
	$sql=stritr($sql,$params);
	$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign("d", $d);
	$sql=rtrim(file_get_contents('sql/zakaz_nal_income_total.sql'));
	$sql=stritr($sql,$params);
	$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign("dt", $d);
}
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=rtrim(file_get_contents('sql/calendar_years.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_years', $data);
$sql=rtrim(file_get_contents('sql/calendar_months.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_months', $data);
$smarty->display('kk_start.html');
$smarty->display('zakaz_nal_income.html');
$smarty->display('kk_end.html');
}
