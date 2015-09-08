<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$id=get_new_id();
$keys = array('id'=>$id,'name'=>$_REQUEST['name'],'test_len'=>$_REQUEST['test_len'],'parent'=>$_REQUEST['parent'],'comm'=>$_REQUEST['comm']);
Table_Update('ac_test', $keys,$keys);
$smarty->assign('id',$id);
$smarty->assign('name',$_REQUEST['name']);
$smarty->assign('test_len',$_REQUEST['test_len']);
$smarty->assign('comm',$_REQUEST['comm']);
$smarty->display('ac_test_new.html');
?>