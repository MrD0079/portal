<?

require_once "bud_svod_zp_ag_total_getRow.php";

InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
InitRequestVar("fil",0);
InitRequestVar("clusters",0);
InitRequestVar("dt",$_SESSION["month_list"]);

$params=array(
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':dt' => "'".$_REQUEST["dt"]."'",
	':eta_list' => "'".$_REQUEST["eta_list"]."'",
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
	':fil' => $_REQUEST["fil"],
	':clusters' => $_REQUEST["clusters"],
);

$sql = rtrim(file_get_contents('sql/bud_svod_gsm_ag.sql'));
$sql=stritr($sql,$params);
//echo $sql;
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ag', $x);

$smarty->display('bud_svod_gsm_ag.html');

?>