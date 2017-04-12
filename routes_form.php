<?

audit("открыл routes_form","routes");

if (isset($_REQUEST["select_month"]))
{
	$_REQUEST["select_route_numb"]=null;
}

if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["selected_changed"])&&isset($_REQUEST["select_route_numb"]))
	{
		foreach ($_REQUEST["selected_changed"] as $k=>$v)
		{
			$table_name = "routes_head_agents";
			$keys = array('head_id'=>$_REQUEST["select_route_numb"],'ag_id'=>$k,'vv'=>0);
			//$vals = array('vv'=>0);
			if ($v=='on')
			{
	        		Table_Update ($table_name, $keys, $keys);
			}
			if ($v=='off')
			{
	        		Table_Update ($table_name, $keys, null);
			}
			//print_r($keys);
			//print_r($values);
		}
	}
}


$sql = rtrim(file_get_contents('sql/routes_head.sql'));
$p=array(":tn"=>$tn,":month_list"=>"'".$_REQUEST["month_list"]."'");
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_head', $res);

if (isset($_REQUEST["select_route_numb"]))
{
if ($_REQUEST["select_route_numb"]!="")
{

$sql = rtrim(file_get_contents('sql/routes_head_agents.sql'));
$p=array(":route"=>$_REQUEST["select_route_numb"]);
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_head_agents', $res);


$sql = rtrim(file_get_contents('sql/routes_body_new.sql'));
$p=array(":route"=>$_REQUEST["select_route_numb"]);
$sql=stritr($sql,$p);
$rb = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($rb as $k=>$v)
{
$d[$v["kodtp"]]["head"]['tz_oblast']=$v['tz_oblast'];
$d[$v["kodtp"]]["head"]['net_name']=$v['net_name'];
$d[$v["kodtp"]]["head"]['ur_tz_name']=$v['ur_tz_name'];
$d[$v["kodtp"]]["head"]['tz_address']=$v['tz_address'];
$d[$v["kodtp"]]["data"][$v["ag_id"]]['head']['ag_name']=$v['ag_name'];
$d[$v["kodtp"]]["data"][$v["ag_id"]]["data"][$v['dm']]['day_num']=$v['day_num'];
$d[$v["kodtp"]]["data"][$v["ag_id"]]["data"][$v['dm']]['day_enabled_mr']=$v['day_enabled_mr'];
$d[$v["kodtp"]]["data"][$v["ag_id"]]["data"][$v['dm']]['day_time_mr']=$v['day_time_mr'];
//$d[$v["kodtp"]]["data"][$v["ag_id"]]["data"][$v['dm']]['day_enabled_f']=$v['day_enabled_f'];
//$d[$v["kodtp"]]["data"][$v["ag_id"]]["data"][$v['dm']]['day_time_f']=$v['day_time_f'];
$d[$v["kodtp"]]["data"][$v["ag_id"]]["data"][$v['dm']]['dw']=$v['dw'];
$d[$v["kodtp"]]["data"][$v["ag_id"]]["data"][$v['dm']]['dwt']=$v['dwt'];
$d[$v["kodtp"]]["data"][$v["ag_id"]]["data"][$v['dm']]['is_wd']=$v['is_wd'];
$d[$v["kodtp"]]["data"][$v["ag_id"]]["data"][$v['dm']]['svms_ok']=$v['svms_ok'];
}
isset($d) ? $smarty->assign('d', $d) : null;
}
}

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$smarty->display('routes_form.html');

?>