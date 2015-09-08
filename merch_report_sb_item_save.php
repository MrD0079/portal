<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$_REQUEST['field']=='srok_god'?$_REQUEST['val']=OraDate2MDBDate($_REQUEST['val']):null;
Table_Update('merch_report_sb',array("id"=>$_REQUEST['id']),array($_REQUEST['field']=>$_REQUEST['val']));
?>