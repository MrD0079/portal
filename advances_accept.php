<?
InitRequestVar("exp_list_without_ts",0);
InitRequestVar("pos_list",0);
InitRequestVar("sd",$_SESSION["month_list"]);
InitRequestVar("cur",array("t.cur_id"));
$cur = join($_REQUEST["cur"],',');

$params=array(
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':sd' => "'".$_REQUEST["sd"]."'",
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':pos_list' => $_REQUEST["pos_list"],
	":cur" => $cur,
);

$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_without_ts', $exp_list_without_ts);

$sql = rtrim(file_get_contents('sql/pos_list_actual.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pos_list', $data);

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$sql=stritr($sql,$params);
$dt = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dt', $dt);

$sql=rtrim(file_get_contents('sql/advances_accept.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('advances', $data);

$sql=rtrim(file_get_contents('sql/advances_accept_total.sql'));
$sql=stritr($sql,$params);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('total', $data);

$sql = rtrim(file_get_contents('sql/advances_accept_ok.sql'));
$sql=stritr($sql,$params);
$x = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ok', $x);


$smarty->display('advances_accept.html');

?>