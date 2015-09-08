<?php

//audit("открыл routes","routes");



InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("routes_eta_list",$_SESSION["h_eta"]);
InitRequestVar("routes_days_list",array());
InitRequestVar("routes_weeks_list",array());

function ar2str($n){return("'".$n."'");}

isset($_REQUEST["routes_days_list"]) ? $routes_days_list_filter = join(array_map("ar2str", $_REQUEST["routes_days_list"]),',') : $routes_days_list_filter = 0;
isset($_REQUEST["routes_weeks_list"]) ? $routes_weeks_list_filter = join(array_map("ar2str", $_REQUEST["routes_weeks_list"]),',') : $routes_weeks_list_filter = 0;

$params=array(':dpt_id' => $_SESSION["dpt_id"],
	":tn"=>$tn,
	":exp_list_without_ts" => $_REQUEST["exp_list_without_ts"],
	":exp_list_only_ts" => $_REQUEST["exp_list_only_ts"],
	":routes_eta_list" => "'".$_REQUEST["routes_eta_list"]."'",
	":routes_days_list" => $routes_days_list_filter,
	":routes_weeks_list" => $routes_weeks_list_filter
);

$sql = rtrim(file_get_contents('sql/routing_childs_list.sql'));
$sql=stritr($sql,$params);
$exp_list_only_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_only_ts', $exp_list_only_ts);

$sql = rtrim(file_get_contents('sql/routing_chief_list.sql'));
$sql=stritr($sql,$params);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_without_ts', $exp_list_without_ts);

$sql = rtrim(file_get_contents('sql/routing_days_list.sql'));
$sql=stritr($sql,$params);
$routes_days_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_days_list', $routes_days_list);

$sql = rtrim(file_get_contents('sql/routing_days_list_1.sql'));
$sql=stritr($sql,$params);
$routes_days_list_1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_days_list_1', $routes_days_list_1);

$sql = rtrim(file_get_contents('sql/routing_eta_list.sql'));
$sql=stritr($sql,$params);
$routes_eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_eta_list', $routes_eta_list);

if (isset($_REQUEST["generate"]))
{
$sql=rtrim(file_get_contents('sql/routing.sql'));
$sql=stritr($sql,$params);
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $list);

$sql=rtrim(file_get_contents('sql/routing_adv.sql'));
$sql=stritr($sql,$params);
$list_adv = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach ($list_adv as $k=>$v){$d[$v["in_route_gr"]][$v["in_route_t"]][$v["day_gr"]][$v["day_t"]][$v["eta_gr"]][$v["eta_t"]]=$v["tp_cnt"];}
isset($d) ? $smarty->assign('list_adv', $d) : null;

$sql=rtrim(file_get_contents('sql/routing_detail.sql'));
$sql=stritr($sql,$params);
$list_detail = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_detail', $list_detail);
}

$smarty->display('routing.html');

?>