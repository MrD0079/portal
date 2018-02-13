<?

InitRequestVar("dates_list",$now);

$sql = rtrim(file_get_contents('sql/merch_report_head.sql'));
$p=array(":data"=>"'".$_REQUEST["dates_list"]."'",":login"=>"'".$login."'");
$sql=stritr($sql,$p);
$r=$db->GetRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('route', $r);

$sql = rtrim(file_get_contents('sql/merch_report_new_vv_tp.sql'));
$p=array(":route"=>$r["id"]);
$sql=stritr($sql,$p);
echo $sql;
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('vv_tp', $res);

$sql=rtrim(file_get_contents('sql/routes_agents.sql'));
$routes_agents = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_agents', $routes_agents);

$smarty->assign('new_id', get_new_id());

$smarty->display('merch_report_new_vv.html');

?>