<?


//$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);





	unlink('files/akcii_local_files/'.$db->getOne('select fn from AKCII_LOCAL_FILES where id='.$_REQUEST['id']));
	$keys = array(
		'id'=>$_REQUEST['id'],
	);
	Table_Update('AKCII_LOCAL_FILES', $keys,null);


?>