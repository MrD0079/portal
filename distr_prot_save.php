<?

$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);




$keys = array(
	'id'=>$_REQUEST['id']
);
$vals = array(
	$_REQUEST['field']=>$_REQUEST['val'],
//	'status_fio'=>$_REQUEST['fio']
);
Table_Update('distr_prot', $keys,$vals);


?>