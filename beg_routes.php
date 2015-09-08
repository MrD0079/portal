<?


InitRequestVar("dt",$now);



$params=array(':dpt_id' => $_SESSION["dpt_id"],
	":tn"=>$tn,
	":dt"=>"'".$_REQUEST["dt"]."'",
);

$sql = rtrim(file_get_contents('sql/beg_routes_ts_list.sql'));
$sql=stritr($sql,$params);
$exp_list_only_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ts_list', $exp_list_only_ts);

$sql = rtrim(file_get_contents('sql/beg_routes_eta_list.sql'));
$sql=stritr($sql,$params);
$routes_eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('eta_list', $routes_eta_list);

$smarty->display('beg_routes.html');

?>