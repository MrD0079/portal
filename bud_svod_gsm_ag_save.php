<?

$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);

$keys = array(
		'id'=>$_REQUEST['id'],
/*
		'dt'=>OraDate2MDBDate($_REQUEST['dt']),
		'dpt_id' => $_SESSION["dpt_id"],
		'unscheduled'=>$_REQUEST['unscheduled'],
		'h_eta'=>$_REQUEST['h_eta'],
*/
);

Table_Update('bud_svod_zp', $keys,$keys);

if ($_REQUEST['field']=='id')
{
	if ($_REQUEST['val']==0)
	{
		Table_Update('bud_svod_zp', $keys,null);
	}
}
else
{
	$vals = array(
		$_REQUEST['field']=>$_REQUEST['val']
	);
	Table_Update('bud_svod_zp', $keys,$vals);
}

?>




