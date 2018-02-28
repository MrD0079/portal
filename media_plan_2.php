<?
InitRequestVar("dates_list1",$_SESSION["month_list"]);
InitRequestVar("dates_list2",$now);
InitRequestVar("id_net",0);
$params=array(
':tn' => $tn,
':dpt_id' => $_SESSION["dpt_id"],
":dates_list1"=>"'".$_REQUEST["dates_list1"]."'",
":dates_list2"=>"'".$_REQUEST["dates_list2"]."'",
":id_net"=>$_REQUEST["id_net"],
);
$sql=rtrim(file_get_contents('sql/nets.sql'));
$sql=stritr($sql,$params);
$nets = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $nets);
if (isset($_REQUEST["select"]))
{
$sql=rtrim(file_get_contents('sql/media_plan_2.sql'));
$sql=stritr($sql,$params);
//$_REQUEST["SQL"]=$sql;
//ses_req();
//exit;
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d', $data);
}
$smarty->display('media_plan_2.html');
?>