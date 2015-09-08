<?

$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);

//print_r($_REQUEST);



$keys = array(
	'ac_id'=>$_REQUEST['id'],
	'comm_tn'=>$_REQUEST['comm'],
	'memb_id'=>$_REQUEST['mk']
);


//Table_Update('os_ac_head', $keys,$keys);




//$head_id=$db->getOne('SELECT id FROM os_ac_head WHERE ac_memb_id = '.$_REQUEST['id']);

/*


$keys = array(
	'head_id'=>$head_id,
	'spr_id'=>$_REQUEST['spr_id']
);
*/
$vals = array(
	$_REQUEST['field']=>$_REQUEST['val']
);
Table_Update('ac_golos', $keys,$vals);


?>