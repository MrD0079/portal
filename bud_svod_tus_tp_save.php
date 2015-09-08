<?



$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);

$keys = array(
	'tp_kod'=>$_REQUEST['tp_kod'],
	'dt'=>OraDate2MDBDate($_REQUEST['dt']),
	'dpt_id' => $_SESSION["dpt_id"]
);

Table_Update('sc_svod', $keys,$keys);

if ($_REQUEST['field']=='tp_kod')
{
	if ($_REQUEST['val']==0)
	{
		Table_Update('sc_svod', $keys,null);
	}
}
else
{
	$vals = array(
		$_REQUEST['field']=>$_REQUEST['val']
	);
	Table_Update('sc_svod', $keys,$vals);
}

?>




