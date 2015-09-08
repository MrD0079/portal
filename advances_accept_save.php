<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);

$keys = array(
	'dpt_id'=>$_SESSION['dpt_id'],
	'm'=>OraDate2MDBDate($_REQUEST['dt']),
);
$vals = array(
	$_REQUEST['field']=>$_REQUEST['val'],
	$_REQUEST['field'].'_fio'=>$fio,
);

Table_Update('advance_ok', $keys,$vals);

if ($_REQUEST['field']=='ok_dpu'&&$_REQUEST['val']==1)
{
	$period=$db->getOne("select mt||' '||y from calendar where data=to_date('".$_REQUEST['dt']."','dd.mm.yyyy')");
	$subj='Завершено согласование авансов на '.$period;
	$sql="SELECT val_string FROM parameters WHERE dpt_id = ".$_SESSION["dpt_id"]." AND param_name IN ('accept1', 'accept2')";
	$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($x as $k=>$v){send_mail($v['val_string'],$subj,'Завершено согласование авансов на '.$period.'. Для перехода к реестру нажмите на <a href="https://ps.avk.ua/?action=advances_accept&sd='.$_REQUEST['dt'].'&select=1">ссылку</a>',null);}
}

?>