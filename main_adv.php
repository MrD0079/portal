<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
//print_r($_REQUEST);
echo "Сохранено";
$keys = array(
	'tn'=>$_REQUEST['tn'],
	'm'=>OraDate2MDBDate($_REQUEST['m']),
);
$vals = array(
	'val'=>$_REQUEST['val'],
	'cur_id'=>$_REQUEST['cur_id'],
	'lu_fio'=>$fio,
);
$_REQUEST['val']==0?$vals=null:null;
Table_Update('advance_tn', $keys,$vals);
?>
