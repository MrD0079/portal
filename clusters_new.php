<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$id=get_new_id();
$keys = array('id'=>$id,'name'=>$_REQUEST['new_cluster_name']/*,'parent'=>$_REQUEST['parent']*/,'dpt_id'=>$_SESSION['dpt_id']);
Table_Update('clusters', $keys,$keys);
//$_REQUEST['id']=$_REQUEST['parent'];
$smarty->assign('id',$id);
$smarty->assign('name',$_REQUEST['new_cluster_name']);
$smarty->display('clusters_new.html');
?>