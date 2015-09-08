<?
$sql=rtrim(file_get_contents('sql/mkk_list.sql'));
$p = array(":tn"=>$tn,':dpt_id'=>$_SESSION['dpt_id']);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('mkk_list', $data);
$smarty->display('mkk.html');
?>