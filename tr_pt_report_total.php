<?

InitRequestVar("sd",$_SESSION["month_list"]);
InitRequestVar("ed",$_SESSION["month_list"]);
InitRequestVar("tr",0);
InitRequestVar("tr_pt_tn",0);
InitRequestVar("completed",1);

$p = array();
$p[':tn'] = $tn;
$p[':dpt_id'] = $_SESSION["dpt_id"];
$p[':tr_pt_tn'] = $_REQUEST["tr_pt_tn"];
$p[':tr'] = $_REQUEST["tr"];
$p[':completed'] = $_REQUEST["completed"];
$p[':sd'] = "'".$_REQUEST["sd"]."'";
$p[':ed'] = "'".$_REQUEST["ed"]."'";

audit("открыл Итоговые результаты тренингов","tr");

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$sql=rtrim(file_get_contents('sql/tr_tn.sql'));
$sql=stritr($sql,$p);
$tr_pt_tn = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tr_pt_tn', $tr_pt_tn);

$sql=rtrim(file_get_contents('sql/tr_pt.sql'));
$sql=stritr($sql,$p);
$tr = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tr', $tr);

if (isset($_REQUEST["generate"]))
{
	$sql=rtrim(file_get_contents('sql/tr_pt_report_total.sql'));
	$sql=stritr($sql,$p);
	//echo $sql;
	$tr_pt_report_total = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	//var_dump($tr_pt_report_total);
	//print_r($d);
	$smarty->assign('d', $tr_pt_report_total);

	$sql=rtrim(file_get_contents('sql/tr_pt_report_total_total.sql'));
	$sql=stritr($sql,$p);
	//echo $sql;
	$tr_pt_report_total_total = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	//var_dump($tr_pt_report_total);
	//print_r($d);
	$smarty->assign('dt', $tr_pt_report_total_total);
}



$smarty->display('tr_pt_report_total.html');

?>