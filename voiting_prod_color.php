<?

if (isset($_REQUEST["saveProd"]))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array('id'=>0);
	if ($_REQUEST["selected"]=='false')
	{
		$vals = array('product'.$_REQUEST["row"]=>$_REQUEST["column"]);
	}
	else
	{
		$vals = array('product'.$_REQUEST["row"]=>null);
	}
	Table_Update('voiting_prod_color', $keys,$vals);
}
else
{
	$sql = rtrim(file_get_contents('sql/voiting_prod_color.sql'));
	$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('voiting_prod_color', $d);
	$smarty->display('voiting_prod_color.html');
}
?>




