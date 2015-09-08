<?
//audit(pathinfo(__FILE__)["filename"],pathinfo(__FILE__)["filename"]);

$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
//ses_req();
$keys = array('dt'=>OraDate2MDBDate($_REQUEST['dt']));
$vals = array($_REQUEST['field']=>$_REQUEST['val']);
//audit("TABLE=ms_tabel, KEYS: head_id=".$_REQUEST['head_id'].", VALS: field=".$_REQUEST['field'].", val=".$_REQUEST['val']."","ms_tabel");
audit("TABLE=ms_tabel, KEYS: ".serialize($keys).", VALS: ".serialize($vals),pathinfo(__FILE__)["filename"]);
Table_Update('ms_tabel_dt', $keys,$vals);
?>




