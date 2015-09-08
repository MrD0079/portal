<?


//ses_req();


audit("открыл tr_plan","tr");

$sql=rtrim(file_get_contents('sql/tr_plan.sql'));
$p = array(":tn"=>$tn,":dpt_id" => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);

//echo $sql;

$tr_plan = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tr_plan', $tr_plan);
$smarty->display('tr_plan.html');

?>