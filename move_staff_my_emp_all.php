<?

$is_db=$db->getOne("select is_db from user_list where tn=".$_REQUEST["tn"]);

if ($is_db==1)
{
$sql=rtrim(file_get_contents('sql/move_staff_my_emp_all.sql'));
$params=array(':tn'=>$_REQUEST["tn"]);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('my_emp_all', $data);
$smarty->display('move_staff_my_emp_all.html');
}

?>