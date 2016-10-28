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

$_REQUEST["tu"]==1?$doc_str="торговые условия":$doc_str="заявка на проведение активности";

$tn=$_REQUEST["tn"];

$sql=rtrim(file_get_contents('sql/bud_ru_zay_view.sql'));
$params=array(':id' => $_REQUEST["id"]);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($data as $k=>$v){
$d["head"]=$v;
$d["data"][$v["acceptor_tn"]]=$v;
}

$sql=rtrim(file_get_contents('sql/bud_ru_zay_view_chat.sql'));
$params=array(':id' => $_REQUEST["id"]);
$sql=stritr($sql,$params);
$chat = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$d["chat"]=$chat;
$url="";
$url.=$doc_str." №".$d["head"]["id"]." от ".$d["head"]["created_dt"];
$url.="\nСогласовано:";
foreach ($d["data"] as $k=>$v)
{
$d["data"][$k]["acceptor_name8"]=mb_convert_encoding($v["acceptor_name"],"UTF-8","Windows-1251");
$url.="\n".$d["data"][$k]["accepted_date"]." ".$d["data"][$k]["acceptor_name"];
}

$url=mb_convert_encoding($url,"UTF-8","Windows-1251");

include "phpqrcode/qrlib.php";
QRcode::png($url, "bud_ru_zay_files/chart".$_REQUEST["id"].".png", "L", 2, 2);

	$sql=rtrim(file_get_contents('sql/bud_ru_zay_get_ff.sql'));
	$p=array(':z_id' => $_REQUEST["id"]);
	$sql=stritr($sql,$p);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($data as $k1=>$v1)
	{
		if ($v1["type"]=="file")
		{
			$data[$k1]["val_file"]=explode("\n",$v1["val_file"]);
		}
		/*if ($v1['type']=='list')
		{
			if ($v1['val_list'])
			{
			$sql=$db->getOne('SELECT get_item FROM bud_ru_ff_subtypes WHERE id = (SELECT subtype FROM bud_ru_ff WHERE id = '.$v1['ff_id'].')');
			$params[':id'] = $v1['val_list'];
			$sql=stritr($sql,$params);
			$list = $db->getOne($sql);
			$data[$k1]['val_list_name'] = $list;
			}
		}*/
	}
	include "bud_ru_zay_formula.php";
	$d["ff"]=$data;

isset($d) ? $smarty->assign('d', $d) : null;

if (!isset($_REQUEST["pdf"]))
{
$a = $smarty->display('bud_ru_zay_view.html');
}
else
{
$a = $smarty->fetch('bud_ru_zay_view.html');
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
$dompdf->stream("bud_ru_zay".$_REQUEST["id"].".pdf");
}
else
{
$dompdf1 = new DOMPDF();
$dompdf1->load_html($b);
$dompdf1->render();
file_put_contents("bud_ru_zay_files/attach".$_REQUEST["id"].".pdf", $dompdf1->output());
}
}
?>