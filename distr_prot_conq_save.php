<?

$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);

$keys = array(
	'id'=>$_REQUEST['id']
//	"dpt_id" => $_SESSION["dpt_id"]
);
$vals = array(
	$_REQUEST['field']=>$_REQUEST['val']
);



if ($_REQUEST['field']=='id')
{
	Table_Update('distr_prot_conq', $keys,null);
}
else
{
	$vals = array(
		$_REQUEST['field']=>$_REQUEST['val']
	);
	Table_Update('distr_prot_conq', $keys,$vals);
}

?>