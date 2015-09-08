<?


///ses_req();

audit("открыл routes_report_by_sku_new","routes");



$sql=rtrim(file_get_contents('sql/routes_agents.sql'));
$ra = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ra', $ra);


$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

InitRequestVar("month_list");
InitRequestVar("svms_list");
InitRequestVar("select_route_numb");

$sql=rtrim(file_get_contents('sql/svms_list.sql'));
$p = array(":tn"=>$tn,':dpt_id'=>$_SESSION['dpt_id']);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('svms_list', $data);



if (isset($_REQUEST["month_list"])&&isset($_REQUEST["svms_list"]))
{
$sql = rtrim(file_get_contents('sql/routes_report_by_sku_new_head.sql'));
$p=array(":tn"=>$tn,":month_list"=>"'".$_REQUEST["month_list"]."'");
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_head', $res);
}



//print_r($res);



if (isset($_REQUEST["month_list"])&&isset($_REQUEST["svms_list"])&&isset($_REQUEST["select_route_numb"])&&isset($_REQUEST["show"]))
{



$sql = rtrim(file_get_contents('sql/routes_report_by_sku_new_body.sql'));
$p=array(
	":select_route_numb"=>$_REQUEST["select_route_numb"],
	":svms_list"=>$_REQUEST["svms_list"],
	":ed"=>"'".$_REQUEST["month_list"]."'"
);
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

//print_r($res);



foreach ($res as $k=>$v)
{
$d[$v["head_id"]]["head"]=$v;
$d[$v["head_id"]]["detail"][$v["ag_id"]]=$v;
}


//print_r($d);


//$d["body"]=$res;

/*
$sql = rtrim(file_get_contents('sql/routes_report_by_sku_new_body_total.sql'));
$p=array(":route"=>$_REQUEST["select_route_numb"],":day"=>$i);
$sql=stritr($sql,$p);
$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
*/

//$routes[$i]["total"]=$res;



//print_r($routes);


isset($d)?$smarty->assign('d', $d):null;

}







$smarty->display('routes_report_by_sku_new.html');

?>