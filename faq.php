<?


$sql=rtrim(file_get_contents('sql/files_faq.sql'));
$params=array(':pos_id'=>$_SESSION["pos_id"],':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn);
$sql=stritr($sql,$params);
$files = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('files', $files);

$smarty->display('faq.html');
?>