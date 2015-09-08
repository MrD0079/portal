<?

$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);


//ses_req();


$keys = array(
	'id'=>$_REQUEST['id']
);
$vals = array(
	$_REQUEST['field']=>$_REQUEST['val']
);


$_REQUEST['field']=='data_end'?$_REQUEST['val']=OraDate2MDBDate($_REQUEST['val']):null;
$_REQUEST['field']=='data_start'?$_REQUEST['val']=OraDate2MDBDate($_REQUEST['val']):null;
$_REQUEST['field']=='data_start_avk'?$_REQUEST['val']=OraDate2MDBDate($_REQUEST['val']):null;




if ($_REQUEST['field']=='id')
{
	Table_Update('bud_fil', $keys,null);
}
else
{
	$vals = array(
		$_REQUEST['field']=>$_REQUEST['val'],
		'lu_fio'=>$fio
	);
	Table_Update('bud_fil', $keys,$vals);
}

?>