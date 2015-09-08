<?

audit("открыл os_ac","os_ac");

$sql=rtrim(file_get_contents('sql/os_ac_list_years.sql'));
$p = array(
':dpt_id' => $_SESSION["dpt_id"]
);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_years', $data);

$smarty->display('os_ac.html');

?>