<?








$sql=rtrim(file_get_contents('sql/nets.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('urlic_net', $data);


$smarty->display('kk_start.html');
$smarty->display('urlic_net.html');
$smarty->display('kk_end.html');



?>