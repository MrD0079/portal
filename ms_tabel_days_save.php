<?
//audit(pathinfo(__FILE__)["filename"],pathinfo(__FILE__)["filename"]);

$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
//audit("сохранил табель М-Сервис, KEYS: head_id=".$_REQUEST['head_id'].", day_num=".$_REQUEST['day_num'].", VALS: field=".$_REQUEST['field'].", val=".$_REQUEST['val']."","ms_tabel");
//ses_req();
$keys = array('head_id'=>$_REQUEST['head_id'],'day_num'=>$_REQUEST['day_num']);
$vals = array($_REQUEST['field']=>$_REQUEST['val']);
audit("TABLE=ms_tabel_days, KEYS: ".serialize($keys).", VALS: ".serialize($vals),pathinfo(__FILE__)["filename"]);
Table_Update('ms_tabel_days', $keys,$vals);
?>