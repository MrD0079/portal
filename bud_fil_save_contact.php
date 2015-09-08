<?

$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);


//ses_req();


$keys = array(
	'id'=>$_REQUEST['id']
);
$vals = array(
	$_REQUEST['field']=>$_REQUEST['val']
);


$_REQUEST['field']=='birthday'?$_REQUEST['val']=OraDate2MDBDate($_REQUEST['val']):null;




if ($_REQUEST['field']=='id')
{
	Table_Update('bud_fil_contacts', $keys,null);
}
else
{
	$vals = array(
		$_REQUEST['field']=>$_REQUEST['val'],
	);
	Table_Update('bud_fil_contacts', $keys,$vals);
}

?>