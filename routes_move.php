<?
//ses_req();
audit("открыл routes_report","routes");
$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);
InitRequestVar("month_list");
InitRequestVar("svms_list");
InitRequestVar("svms_list_move");
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
if (
        isset($_REQUEST["month_list"])&&
        isset($_REQUEST["svms_list"])&&
        isset($_REQUEST["select_route_numb"])&&
        isset($_REQUEST["move"])&&
        isset($_REQUEST["svms_list_move"]))
{
    $route_num=$db->getOne("select num from routes_head where id=".$_REQUEST["select_route_numb"]);
    $svms_from=$db->getOne("select fio from user_list where tn=".$_REQUEST["svms_list"]);
    $svms_to=$db->getOne("select fio from user_list where tn=".$_REQUEST["svms_list_move"]);
    $response=$now_date_time." машрут ".$route_num." привязан к ".$svms_to;
    $response="машрут ".$route_num." перепривязан от ".$svms_from." к ".$svms_to;
    $smarty->assign('response', $response);
    //print_r($_REQUEST);
    $keys = array('id'=>$_REQUEST["select_route_numb"]);
    $vals = array('tn'=>$_REQUEST["svms_list_move"]);
    $db->query("INSERT INTO svms_oblast (tn, oblast)
                SELECT ".$_REQUEST["svms_list_move"].", oblast
                FROM svms_oblast
                WHERE     tn = ".$_REQUEST["svms_list"]."
                AND oblast NOT IN (SELECT oblast
                                   FROM svms_oblast
                                   WHERE tn = ".$_REQUEST["svms_list_move"].")");
    Table_Update ("routes_head", $keys, $vals);
    audit($response,"routes_move");
    $_REQUEST["svms_list"]=0;
    $_REQUEST["svms_list_move"]=0;
    $_REQUEST["select_route_numb"]=0;
}
$smarty->display('routes_move.html');
?>