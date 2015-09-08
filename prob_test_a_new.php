<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$id=get_new_id();
$keys = array('id'=>$id,'name'=>$_REQUEST['name'],'a_ok'=>$_REQUEST['a_ok'],'parent'=>$_REQUEST['parent']);
Table_Update('prob_test', $keys,$keys);
$smarty->assign('id',$id);
$smarty->assign('name',$_REQUEST['name']);
$smarty->assign('a_ok',$_REQUEST['a_ok']);
$smarty->display('prob_test_a_new.html');
?>