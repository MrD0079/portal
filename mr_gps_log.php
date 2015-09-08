<?
audit("просмотрел лог GPS");



InitRequestVar("dates_list1",$_SESSION["month_list"]);
InitRequestVar("dates_list2",$now);



if (isset($_REQUEST["select"]))
{

$sql = rtrim(file_get_contents('sql/mr_gps_log.sql'));









$params = array(
"dates_list1"=>$_REQUEST["dates_list1"],
"dates_list2"=>$_REQUEST["dates_list2"]
);


$res = $db->getAll($sql, null, $params, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('mr_gps_log', $res);


}


$smarty->display('mr_gps_log.html');



?>