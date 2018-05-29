<?
if (isset($_REQUEST["to_file"]))
{
require_once "function.php";
require_once "local_functions.php";
require_once 'MDB2.php';
$dsn = 'oci8://persik:razvitie@'.ZAOIBM;
$db =& MDB2::connect($dsn);
$db->loadModule('Extended');
$db->loadModule('Function');
}

$sql=rtrim(file_get_contents('sql/sz_view.sql'));
$params=array(':id' => $_REQUEST["id"]);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($data as $k=>$v){
$d["head"]=$v;
$d["data"][$v["acceptor_tn"]]=$v;
$d["files"][$v["fn"]]=$v;
}

$sql=rtrim(file_get_contents('sql/sz_view_chat.sql'));
$params=array(':id' => $_REQUEST["id"]);
$sql=stritr($sql,$params);
$chat = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$d["chat"]=$chat;
$url="";
$d["head"]["head8"]=mb_convert_encoding($d["head"]["head"],"UTF-8","Windows-1251");
$url.="СЗ №".$d["head"]["id"]." от ".$d["head"]["created_dt"];
$url.="\nТема:\n".$d["head"]["head"];
$url.="\nСогласовано:";
foreach ($d["data"] as $k=>$v)
{
$d["data"][$k]["acceptor_name8"]=mb_convert_encoding($v["acceptor_name"],"UTF-8","Windows-1251");
//$url.=rawurlencode(" ".$d["data"][$k]["acceptor_name8"]." ".$d["data"][$k]["accepted_date"]);
//$url.=rawurlencode(" ".$d["data"][$k]["acceptor_name"]." ".$d["data"][$k]["accepted_date"]);
$url.="\n".$d["data"][$k]["accepted_date"]." ".$d["data"][$k]["acceptor_name"];
}
$url=mb_convert_encoding($url,"UTF-8","Windows-1251");
include "phpqrcode/qrlib.php";
QRcode::png($url, "files/chart".$_REQUEST["id"].".png", "L", 2, 2);
isset($d) ? $smarty->assign('d', $d) : null;

if (!isset($_REQUEST["pdf"]))
{
$a = $smarty->display('sz_view.html');
}
else
{
$a = $smarty->fetch('sz_view.html');
require_once("dompdf/dompdf_config.inc.php");
$a ='
<html>
<head>
<meta	http-equiv="Content-Type"	content="charset=utf-8" />
<style type="text/css"> * {font-family: "DejaVu Sans Mono", monospace;}</style>
</head>
<body>
'.$a.'
</body>
</html>';
$b = mb_convert_encoding($a,"UTF-8","Windows-1251");
if (!isset($_REQUEST["to_file"]))
{
$dompdf = new DOMPDF();
$dompdf->load_html($b);
$dompdf->render();
$dompdf->stream("sz".$_REQUEST["id"].".pdf");
}
else
{
$dompdf1 = new DOMPDF();
$dompdf1->load_html($b);
$dompdf1->render();
file_put_contents("files/attach".$_REQUEST["id"].".pdf", $dompdf1->output());
}
}
?>