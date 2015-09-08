<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$keys = array('id'=>$_REQUEST['id']);
$vals = array($_REQUEST['field']=>$_REQUEST['val']);
Table_Update('ol_staff', $keys,$vals);
?>




