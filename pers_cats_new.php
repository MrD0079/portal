<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$id=get_new_id();
$keys = array('id'=>$id,'name'=>$_REQUEST['new_pers_cat_name']);
Table_Update('pers_cats', $keys,$keys);
$smarty->assign('id',$id);
$smarty->assign('name',$_REQUEST['new_pers_cat_name']);
$smarty->display('pers_cats_new.html');
?>