<?
InitRequestVar("dates_list1",$_SESSION["month_list"]);
InitRequestVar("dates_list2",$now);
InitRequestVar("du1",$_SESSION["month_list"]);
InitRequestVar("du2",$now);
InitRequestVar("exp_list_without_ts",0);
InitRequestVar("staff_list",0);
InitRequestVar("not_accepted",1);
InitRequestVar("date_between","accept_data");

//InitRequestVar("ol_arch_id",0);
!isset($_REQUEST["ol_arch_id"])?$_REQUEST["ol_arch_id"]=0:null;

$params=array(
	':dpt_id' => $_SESSION["dpt_id"],
	':tn'=>$tn,
	":dates_list1"=>"'".$_REQUEST["dates_list1"]."'",
	":dates_list2"=>"'".$_REQUEST["dates_list2"]."'",
	":du1"=>"'".$_REQUEST["du1"]."'",
	":du2"=>"'".$_REQUEST["du2"]."'",
	":date_between"=>"'".$_REQUEST["date_between"]."'",
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':staff_list' => $_REQUEST["staff_list"],
	':ol_arch_id' => $_REQUEST["ol_arch_id"],
	':not_accepted' => $_REQUEST["not_accepted"]
);

if($_REQUEST["ol_arch_id"]!=0)
{
$params[':dpt_id']=$db->getOne('select dpt_id from user_list where tn=(select tn from free_staff where id='.$_REQUEST["ol_arch_id"].')');
}

$sql = rtrim(file_get_contents('sql/ol_arch_chief_list.sql'));
$sql=stritr($sql,$params);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_without_ts', $exp_list_without_ts);

$sql = rtrim(file_get_contents('sql/ol_arch_staff_list.sql'));
$sql=stritr($sql,$params);
$staff_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('staff_list', $staff_list);

$sql=rtrim(file_get_contents('sql/ol_arch_head.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($data as $k=>$v)
{
$p = array(':tn'=>$tn,':id' => $v["id"]);
$sql=rtrim(file_get_contents('sql/ol_arch_body.sql'));
$sql=stritr($sql,$p);
//echo $sql."<br>";
$data1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$data[$k]['body']=$data1;
foreach ($data1 as $k1=>$v1)
{
if (file_exists("files/ol_files/".$v1["id"]))
{

			$file_list=array();
			if ($handle = opendir("files/ol_files/".$v1["id"])) {
				while (false !== ($file = readdir($handle)))
				{
					if ($file != "." && $file != "..") {$file_list[] = $file;}
				}
				closedir($handle);
			}
			$data[$k]['body'][$k1]["fl"]=$file_list;
}
}
}

$smarty->assign('ol_arch', $data);

//$smarty->display('ol_arch.html');




if(
($_REQUEST["ol_arch_id"]==0)
||
(isset($_REQUEST["excel"]))
)
{
//$a = $smarty->fetch('ol_arch.html');

$smarty->display('ol_arch.html');
}
else
{
$a = $smarty->fetch('ol_arch.html');
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
//echo $a;
$b = mb_convert_encoding($a,"UTF-8","Windows-1251");
$dompdf = new DOMPDF();
$dompdf->load_html($b);
$dompdf->render();


if (isset($_REQUEST["pdf"]))
{
$dompdf->stream($_REQUEST["filename"].".pdf");
}
else
{
file_put_contents("files/ol_files/attach".$_REQUEST["ol_arch_id"].".pdf", $dompdf->output());
}



}
?>