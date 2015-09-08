<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$id=get_new_id();
$keys = array('id'=>$id,'fil'=>$_REQUEST['parent']);
Table_Update('bud_fil_contacts', $keys,$keys);
//$_REQUEST['id']=$_REQUEST['parent'];
$smarty->assign('id',$id);
//$smarty->assign('name',$_REQUEST['new_list_name']);
$smarty->display('bud_fil_passport_new_contact.html');
?>