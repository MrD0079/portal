<?

require_once "bud_svod_zp_ag_total_getRow.php";

InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
InitRequestVar("ok_bonus",1);
InitRequestVar("fil",0);
InitRequestVar("clusters",0);
InitRequestVar("dt",$_SESSION["month_list"]);

$params=array(
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':dt' => "'".$_REQUEST["dt"]."'",
	':eta_list' => "'".$_REQUEST["eta_list"]."'",
	':ok_bonus' => $_REQUEST["ok_bonus"],
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
	':fil' => $_REQUEST["fil"],
	':clusters' => $_REQUEST["clusters"],
);

$sql = rtrim(file_get_contents('sql/bud_svod_tun_tp.sql'));
$sql=stritr($sql,$params);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp', $x);

$sql = rtrim(file_get_contents('sql/bud_svod_tun_tpn.sql'));
$sql=stritr($sql,$params);
//echo $sql;
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$sqld = rtrim(file_get_contents('sql/bud_svod_tun_tpn_det.sql'));
foreach ($x as $k=>$v)
{
	$params[":net_kod"]=$v["net_kod"];
	$params[":db"]=$v["db"];
	$sqld1=stritr($sqld,$params);
	$x1 = $db->getAll($sqld1, null, null, null, MDB2_FETCHMODE_ASSOC);
	$x[$k]["det"]=$x1;
}
//print_r($x);
$smarty->assign('tpn', $x);

$smarty->display('bud_svod_tun_tp.html');

?>