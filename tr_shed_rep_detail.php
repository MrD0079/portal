<?



audit ("������ ����� �� ��������� detail","tr");

$params=array(':tn'=>$tn,':id'=>$_REQUEST["tr_id"]);

$sql=rtrim(file_get_contents('sql/tr_shed_rep_detail.sql'));
$sql=stritr($sql,$params);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d', $r);

$smarty->display('tr_shed_rep_detail.html');



?>