<?php
if (isset($_REQUEST['save']))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array('dt'=>OraDate2MDBDate($_REQUEST['dt']),'tp_kod'=>$_REQUEST['tp_kod']);
	$vals = array($_REQUEST['key']=>$_REQUEST['val']);
	Table_Update('tpplan', $keys,$vals);
}
else
{
InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
InitRequestVar("days");
$_REQUEST['days']==''?$_REQUEST['days']=-1:null;
$params=array(
	":dpt_id" => $_SESSION["dpt_id"],
	":tn"=>$tn,
	":exp_list_without_ts" => $_REQUEST["exp_list_without_ts"],
	":exp_list_only_ts" => $_REQUEST["exp_list_only_ts"],
	":eta_list" => "'".$_REQUEST["eta_list"]."'",
	":dw_num" => $_REQUEST['days'],
	":dt" => "'".$_REQUEST["month_list"]."'",
);
$smarty->assign('this_month_name', $db->getOne("select mt from calendar where data=to_date('".$_REQUEST["month_list"]."','dd.mm.yyyy')"));
$smarty->assign('prev_month_name_1', $db->getOne("select mt from calendar where data=ADD_MONTHS(to_date('".$_REQUEST["month_list"]."','dd.mm.yyyy'), -1)"));
$smarty->assign('prev_month_name_2', $db->getOne("select mt from calendar where data=ADD_MONTHS(to_date('".$_REQUEST["month_list"]."','dd.mm.yyyy'), -2)"));
$smarty->assign('prev_month_name_3', $db->getOne("select mt from calendar where data=ADD_MONTHS(to_date('".$_REQUEST["month_list"]."','dd.mm.yyyy'), -3)"));
$sql = rtrim(file_get_contents('sql/exp_list_from_parent_only_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_only_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_only_ts', $exp_list_only_ts);
$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_without_ts', $exp_list_without_ts);
$sql = rtrim(file_get_contents('sql/eta_list.sql'));
$sql=stritr($sql,$params);
$eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('eta_list', $eta_list);
$sql = rtrim(file_get_contents('sql/tpplan_days_list.sql'));
$sql=stritr($sql,$params);
$days_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('days_list', $days_list);
$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);
if (isset($_REQUEST["generate"]))
{
$sql=rtrim(file_get_contents('sql/tpplan.sql'));
$sql=stritr($sql,$params);
//echo $sql;
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $list);
$sql=rtrim(file_get_contents('sql/tpplant.sql'));
$sql=stritr($sql,$params);
//echo $sql;
$listt = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('listt', $listt);
$sql=rtrim(file_get_contents('sql/tpplants.sql'));
$sql=stritr($sql,$params);
//echo $sql;
$listts = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('listts', $listts);
}
$smarty->display('tpplan.html');
}

?>