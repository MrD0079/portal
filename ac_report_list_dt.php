<?

audit("открыл ac_report_list_dt","ac_report_list_dt");

$sql=rtrim(file_get_contents('sql/ac_report_list_dt.sql'));
$p = array(
':dpt_id' => $_SESSION["dpt_id"],
':y' => $_REQUEST["y"]
);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ac_report_list_dt', $data);


//print_r($data);

$smarty->display('ac_report_list_dt.html');

?>