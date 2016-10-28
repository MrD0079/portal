<?
require_once "bud_svod_zp_ag_total_getRow.php";
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
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':db' => $_REQUEST["db"],
	':fil' => $_REQUEST["fil"],
	':clusters' => $_REQUEST["clusters"],
	':ok_db' => $_REQUEST["ok_db"],
	':ok_t1' => $_REQUEST["ok_t1"],
	':ok_pr' => $_REQUEST["ok_pr"],
	':ok_t2' => $_REQUEST["ok_t2"],
);
$sql = rtrim(file_get_contents('sql/bud_funds.sql'));
$sql=stritr($sql,$params);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach ($x as $k=>$v)
{
	$d[$v['kod']]['fund_name']=$v['name'];
}
isset($d)?$smarty->assign('funds', $d):null;

$d1=date("Y-m-d H:i:s");
$smarty->assign('d1', $d1);

$sql = rtrim(file_get_contents('sql/bud_svod_ta_list.sql'));
$sql=stritr($sql,$params);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('x', $x);

$d2=date("Y-m-d H:i:s");
$smarty->assign('d2', $d2);

$sql = rtrim(file_get_contents('sql/bud_svod_ta_list_total.sql'));
$sql=stritr($sql,$params);
$x = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('xt', $x);

$d3=date("Y-m-d H:i:s");
$smarty->assign('d3', $d3);

$smarty->display('bud_svod_ta_list.html');
?>