<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$id=get_new_id();
$keys = array('id'=>$id,'cost_item'=>$_REQUEST['new_cost_item'],'parent'=>$_REQUEST['parent']/*,'dpt_id'=>$_SESSION['dpt_id']*/);
Table_Update('statya', $keys,$keys);
$_REQUEST['id']=$_REQUEST['parent'];
$smarty->assign('id',$id);
$smarty->assign('cost_item',$_REQUEST['new_cost_item']);
$smarty->display('statyas_new.html');
?>