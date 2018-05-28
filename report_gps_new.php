<?php


audit("открыл сводный отчет М-Сервис","report_gps_new");

InitRequestVar("dates_list1",$_REQUEST["dates_list"]);
InitRequestVar("dates_list2",$_REQUEST["dates_list"]);
InitRequestVar("svms_list",0);
InitRequestVar("otv_list","0");
InitRequestVar("num_list","0");



InitRequestVar("report_gps_new_page","period");


//ses_req();

/*
$sql = rtrim(file_get_contents('sql/dates_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dates_list', $res);
*/

$sql=rtrim(file_get_contents('sql/svms_list.sql'));
$p = array(":tn"=>$tn,':dpt_id'=>$_SESSION['dpt_id'],":login"=>"'".$login."'");
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('svms_list', $data);

$sql=rtrim(file_get_contents('sql/report_gps_new_otv_list.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"],":ed"=>"'".$_REQUEST["dates_list2"]."'",":tn"=>$tn);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('otv_list', $data);

$sql=rtrim(file_get_contents('sql/report_gps_new_num_list.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"],":ed"=>"'".$_REQUEST["dates_list2"]."'",":tn"=>$tn);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('num_list', $data);

if (isset($_REQUEST["select"]))
{
$p=array(
":tn"=>$tn,
":svms_list"=>$_REQUEST["svms_list"],
":otv_list"=>"'".$_REQUEST["otv_list"]."'",
":num_list"=>"'".$_REQUEST["num_list"]."'",
":sd"=>"'".$_REQUEST["dates_list1"]."'",
":ed"=>"'".$_REQUEST["dates_list2"]."'"
);

$sql = rtrim(file_get_contents('sql/report_gps_new_by_'.$_REQUEST['report_gps_new_page'].'.sql'));
$sql=stritr($sql,$p);
//echo $sql;
//exit;
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d', $res);

}


$smarty->display('report_gps_new.html');

?>