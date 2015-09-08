<?

InitRequestVar("exp_list_without_ts",0);
InitRequestVar("db",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
InitRequestVar("fil",0);
InitRequestVar("clusters",0);
InitRequestVar("dt",$_SESSION["month_list"]);
InitRequestVar("funds",0);
InitRequestVar("ok_db",1);
InitRequestVar("ok_t1",1);
InitRequestVar("ok_pr",1);
InitRequestVar("ok_t2",1);

$params=array(
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':dt' => "'".$_REQUEST["dt"]."'",
	':login' => "'".$login."'",
);

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$sql=stritr($sql,$params);
$dt = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dt', $dt);

$sql = rtrim(file_get_contents('sql/bud_db_list.sql'));
$sql=stritr($sql,$params);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('db', $x);

$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_without_ts', $exp_list_without_ts);

$sql = rtrim(file_get_contents('sql/bud_svod_list_fil.sql'));
$sql=stritr($sql,$params);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('fil', $x);

$sql = rtrim(file_get_contents('sql/bud_svod_list_cluster.sql'));
$sql = stritr($sql,$params);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('clusters', $r);

$smarty->display('bud_svod_ta.html');

if (isset($_REQUEST['print']))
{
require_once "bud_svod_ta_list.php";
}


?>