<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$keys = array('id'=>$_REQUEST['id']);
Table_Update('pers_cats', $keys,$keys);
if ($_REQUEST['field']=='id')
{
	if ($_REQUEST['val']==0){Table_Update('pers_cats', $keys,null);}
}
else
{
	$vals = array($_REQUEST['field']=>$_REQUEST['val']);
	Table_Update('pers_cats', $keys,$vals);
}
?>




