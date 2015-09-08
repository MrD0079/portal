<?

audit("открыл os_ac_list_dt","os_ac_list_dt");

$sql=rtrim(file_get_contents('sql/os_ac_list_dt.sql'));
$p = array(
':dpt_id' => $_SESSION["dpt_id"],
':y' => $_REQUEST["y"]
);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('os_ac_list_dt', $data);


//print_r($data);

$smarty->display('os_ac_list_dt.html');

?>