<?

$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
if ($_REQUEST['id']=='null')
{
	$keys = array('id'=>get_new_id());
	$vals = $keys;
}
else
{
	$keys = array('id'=>$_REQUEST['id']);
	if ($_REQUEST['field']=='id')
	{
		$vals=null;
	}
	else
	{
		$vals = array($_REQUEST['field']=>$_REQUEST['val']);
	}
}

if ($_REQUEST['parent']!='null')
{
	$keys['parent']=$_REQUEST['parent'];
}

if ($_REQUEST['field']=='day'&&$_REQUEST['val']=='null')
{
	$vals=null;
}

Table_Update($_REQUEST['table'], $keys,$vals);
?>




