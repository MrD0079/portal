<?

audit("открыл os_ac_list_memb","os_ac_list_memb");

$sql=rtrim(file_get_contents('sql/os_ac_list_memb.sql'));
$p = array(
':id' => $_REQUEST["id"]
);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('os_ac_list_memb', $data);


//print_r($data);

$smarty->display('os_ac_list_memb.html');

?>