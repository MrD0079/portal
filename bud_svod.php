<?



audit("открыл bud_svod","bud");

InitRequestVar("page");
InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
InitRequestVar("ok_bonus",1);
InitRequestVar("cash",1);
InitRequestVar("fakt_gt_plan",1);
InitRequestVar("fil",0);
InitRequestVar("clusters",0);
InitRequestVar("dt",$_SESSION["month_list"]);

$p = array(":tn" => $tn);
$p[":dpt_id"] = $_SESSION["dpt_id"];

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$sql=stritr($sql,$p);
$dt = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dt', $dt);

$smarty->display('bud_svod.html');

if (isset($_REQUEST['print']))
{
require_once "bud_svod_tus.php";
require_once "bud_svod_tus_tp_total.php";
require_once "bud_svod_tus_tp.php";
}

//require_once "bud_svod_zp_ag_total.php";


?>