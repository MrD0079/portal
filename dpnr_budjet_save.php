<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$keys = array(
'market'=>$_REQUEST['market'],
'dt'=>OraDate2MDBDate($_REQUEST['dt'])
);

isset($_REQUEST['st'])?$keys['st']=$_REQUEST['st']:null;
isset($_REQUEST['cmp'])?$keys['cmp']=$_REQUEST['cmp']:null;

$vals = array($_REQUEST['field']=>$_REQUEST['val']);
Table_Update('dpnr_budjet_'.$_REQUEST['table'], $keys,$vals);
?>




