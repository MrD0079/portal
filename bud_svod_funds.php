<?

InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
InitRequestVar("fil",0);
InitRequestVar("clusters",0);
InitRequestVar("sd",$_SESSION["month_list"]);
InitRequestVar("ed",$_SESSION["month_list"]);
InitRequestVar("funds",0);
InitRequestVar("db",0);
InitRequestVar("st",0);

$params=array(
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':sd' => "'".$_REQUEST["sd"]."'",
	':ed' => "'".$_REQUEST["ed"]."'",
	':dt' => "'".$_REQUEST["ed"]."'",
	':login' => "'".$login."'",
);

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$sql=stritr($sql,$params);
$dt = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dt', $dt);

$sql = rtrim(file_get_contents('sql/exp_list_from_parent_only_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_only_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_only_ts', $exp_list_only_ts);

$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_without_ts', $exp_list_without_ts);

$sql = rtrim(file_get_contents('sql/bud_svod_list_eta.sql'));
$sql=stritr($sql,$params);
$eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('eta_list', $eta_list);

$sql = rtrim(file_get_contents('sql/bud_svod_list_fil.sql'));
$sql=stritr($sql,$params);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('fil', $x);

$sql = rtrim(file_get_contents('sql/bud_svod_list_cluster.sql'));
$sql = stritr($sql,$params);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('clusters', $r);

$sql = rtrim(file_get_contents('sql/bud_svod_list_funds.sql'));
$sql = stritr($sql,$params);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('funds', $r);

$sql = rtrim(file_get_contents('sql/bud_db_list.sql'));
$sql=stritr($sql,$params);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('db', $x);

$sql=rtrim(file_get_contents('sql/bud_ru_st_ras.sql'));
$sql=stritr($sql,$params);
$st = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('st', $st);

$smarty->display('bud_svod_funds.html');

?>