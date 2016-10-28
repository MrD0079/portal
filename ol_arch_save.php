<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$keys = array('id'=>$_REQUEST['id']);
$_REQUEST['field']=='datauvol'?$_REQUEST['val']=OraDate2MDBDate($_REQUEST['val']):null;
$vals = array($_REQUEST['field']=>$_REQUEST['val']);
Table_Update($_REQUEST['table'], $keys,$vals);
?>




