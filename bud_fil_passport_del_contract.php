<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$keys = array(
	'id'=>$_REQUEST['id'],
);
Table_Update('bud_fil_contracts', $keys,null);
?>