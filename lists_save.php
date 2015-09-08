<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$keys = array('id'=>$_REQUEST['id']);
Table_Update('lists', $keys,$keys);
if ($_REQUEST['field']=='id')
{
	if ($_REQUEST['val']==0){Table_Update('lists', $keys,null);}
}
else
{
	$vals = array($_REQUEST['field']=>$_REQUEST['val']);
	Table_Update('lists', $keys,$vals);
}
?>




