<?



$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);

$keys = array(
//	'tp_kod'=>$_REQUEST['tp_kod'],
	'dt'=>OraDate2MDBDate($_REQUEST['dt']),
	'dpt_id' => $_SESSION["dpt_id"],
);



if (strpos($_REQUEST["id"],"_")===false)
{
	$keys["tp_kod"]=$_REQUEST['id'];
}
else
{
	$k = explode("_",$_REQUEST["id"]);
	$keys["net_kod"]=$k[0];
	$keys["db"]=$k[1];
	$keys["fil"]=$k[2];
}



Table_Update('sc_svodn', $keys,$keys);

if ($_REQUEST['field']=='tp_kod'||$_REQUEST['field']=='net_kod_db_fil')
{
	if ($_REQUEST['val']==0)
	{
		Table_Update('sc_svodn', $keys,null);
	}
}
else
{
	$vals = array(
		$_REQUEST['field']=>$_REQUEST['val'],
		'lu_tn' => $tn,
	);
	Table_Update('sc_svodn', $keys,$vals);
}
/*
$_REQUEST["keys"]=$keys;
$_REQUEST["vals"]=$vals;
*/
?>




