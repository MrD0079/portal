<?

InitRequestVar("sd",$_SESSION["month_list"]);
InitRequestVar("ed",$_SESSION["month_list"]);
InitRequestVar("report_list");
InitRequestVar("exp_list");

InitRequestVar("cur",array(-1));
$cur = join($_REQUEST["cur"],',');

audit("открыл cводные данные по отчетам о затратах","zat");

$sql=rtrim(file_get_contents('sql/currencies.sql'));
$currencies = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('currencies', $currencies);

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$params = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql = rtrim(file_get_contents('sql/exp_list.sql'));
$sql=stritr($sql,$params);
$exp_list = &$db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list', $exp_list);

if (isset($_REQUEST["report_list"]))
{
	if ($_REQUEST["report_list"]!=0)
	{
		$v=$_REQUEST["report_list"];
		!isset($_REQUEST["exp_list"]) ? $_REQUEST["exp_list"]=0 : null;
		($v==1||$v==2) ? $full='1' : null;
		($v==3||$v==4) ? $full='0' : null;
		($v==5||$v==6) ? $full='10' : null;
		//($v==5||$v==6) ? $exp_tn=$_REQUEST["exp_list"] : $exp_tn=$tn;
		$exp_tn=$_REQUEST["exp_list"];
		($v==3||$v==5) ? $v=1 : null;
		($v==4||$v==6) ? $v=2 : null;
		($exp_tn==0) ? $exp_tn=$tn : null;
		$params = array(
			":cur" => $cur,
			':full' => $full,
			':exp_tn' => $exp_tn,
			':tn' => $tn,
			':dpt_id' => $_SESSION["dpt_id"],
			':sd' => "'".$_REQUEST["sd"]."'",
			':ed' => "'".$_REQUEST["ed"]."'"
			);
		//print_r($params);
		//echo $v;
		$sql = rtrim(file_get_contents("sql/zat_reports_".$v.".sql"));
		$sql=stritr($sql,$params);
		//echo $sql;
		$zat_reports = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('zat_reports', $zat_reports);
		$sql = rtrim(file_get_contents("sql/zat_reports_".$v."_total.sql"));
		$sql=stritr($sql,$params);
		$zat_reports_total = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('zat_reports_total', $zat_reports_total);
	}
}

$smarty->display('zat_reports.html');

?>