<?

$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);

//print_r($_REQUEST);



$keys = array(
	'ac_memb_id'=>$_REQUEST['id'],
	'ac_memb_type'=>$_REQUEST['ie']
);
$vals = array(
	$_REQUEST['field']=>$_REQUEST['val']
);
Table_Update('os_ac_head', $keys,$vals);


?>