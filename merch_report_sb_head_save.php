<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
Table_Update('merch_report_sb_head',array("id"=>$_REQUEST['id']),array($_REQUEST['field']=>$_REQUEST['val']));
?>