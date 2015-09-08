<?
$sql=rtrim(file_get_contents('sql/iv_create_list.sql'));
$params=array(':tn' => $tn, ':dpt_id' => $_SESSION['dpt_id']);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $data);
$sql=rtrim(file_get_contents('sql/iv_st.sql'));
$iv_st = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('iv_st', $iv_st);
$_REQUEST['id']!=='0'?$id=$_REQUEST['id']:$id=get_new_id();
$sql=rtrim(file_get_contents('sql/iv_create_body_item.sql'));
$params=array(':id' => $id);
$sql=stritr($sql,$params);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('body_item', $data);
$smarty->assign('id', $id);
$smarty->display('iv_create_list.html');
?>