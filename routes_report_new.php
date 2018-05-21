<?
//ses_req();
audit("открыл routes_report","routes");
$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);
InitRequestVar("month_list");
InitRequestVar("svms_list");
InitRequestVar("select_route_numb");
if (isset($_REQUEST["month_list"]))
{
$sql=rtrim(file_get_contents('sql/svms_list.sql'));
$p = array(":tn"=>$tn,':dpt_id'=>$_SESSION['dpt_id']);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('svms_list', $data);
}
if (isset($_REQUEST["month_list"])&&isset($_REQUEST["svms_list"]))
{
$sql = rtrim(file_get_contents('sql/routes_head.sql'));
$p=array(":tn"=>$_REQUEST["svms_list"],":month_list"=>"'".$_REQUEST["month_list"]."'");
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_head', $res);
}
if (isset($_REQUEST["month_list"])&&isset($_REQUEST["svms_list"])&&isset($_REQUEST["select_route_numb"])&&isset($_REQUEST["show"]))
{
$sql = rtrim(file_get_contents('sql/routes_report_new_head.sql'));
$p=array(":route"=>$_REQUEST["select_route_numb"]);
$sql=stritr($sql,$p);
$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('head', $res);
$sql = rtrim(file_get_contents('sql/routes_report_new_days_list.sql'));
$p=array(":route"=>$_REQUEST["select_route_numb"]);
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//$smarty->assign('routes', $res);
//print_r($res);
$routes = $res;
foreach($res as $k=>$v)
{
$sql = rtrim(file_get_contents('sql/routes_report_new_body.sql'));
$p=array(":route"=>$_REQUEST["select_route_numb"],":day"=>$v['dm']);
$sql=stritr($sql,$p);
$res1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach($res1 as $k1=>$v1)
{
$routes[$k]["body"][$v1["kodtp"]]["head"]["tz_oblast"]=$v1["tz_oblast"];
$routes[$k]["body"][$v1["kodtp"]]["head"]["net_name"]=$v1["net_name"];
$routes[$k]["body"][$v1["kodtp"]]["head"]["ur_tz_name"]=$v1["ur_tz_name"];
$routes[$k]["body"][$v1["kodtp"]]["head"]["tz_address"]=$v1["tz_address"];
$routes[$k]["body"][$v1["kodtp"]]["agents"][$v1["ag_id"]]["ag_name"]=$v1["ag_name"];
$routes[$k]["body"][$v1["kodtp"]]["agents"][$v1["ag_id"]]["day_enabled_mr"]=$v1["day_enabled_mr"];
$routes[$k]["body"][$v1["kodtp"]]["agents"][$v1["ag_id"]]["day_time_mr"]=$v1["day_time_mr"];
//$routes[$k]["body"][$v1["kodtp"]]["agents"][$v1["ag_name"]]["day_enabled_f"]=$v1["day_enabled_f"];
//$routes[$k]["body"][$v1["kodtp"]]["agents"][$v1["ag_name"]]["day_time_f"]=$v1["day_time_f"];
}
$sql = rtrim(file_get_contents('sql/routes_report_new_body_total.sql'));
$p=array(":route"=>$_REQUEST["select_route_numb"],":day"=>$v['dm']);
$sql=stritr($sql,$p);
$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$routes[$k]["total"]=$res;
}
//print_r($routes);
$smarty->assign('routes', $routes);
}
$smarty->display('routes_report_new.html');
?>