<?

//ses_req();

audit("открыл negot_proc","fin_plan");


if (isset($_REQUEST["calendar_years"])){$_SESSION["calendar_years"]=$_REQUEST["calendar_years"];}else{if (isset($_SESSION["calendar_years"])){$_REQUEST["calendar_years"]=$_SESSION["calendar_years"];}}
if (isset($_REQUEST["tn_rmkk"])){$_SESSION["tn_rmkk"]=$_REQUEST["tn_rmkk"];}else{if (isset($_SESSION["tn_rmkk"])){$_REQUEST["tn_rmkk"]=$_SESSION["tn_rmkk"];}}
if (isset($_REQUEST["tn_mkk"])){$_SESSION["tn_mkk"]=$_REQUEST["tn_mkk"];}else{if (isset($_SESSION["tn_mkk"])){$_REQUEST["tn_mkk"]=$_SESSION["tn_mkk"];}}
if (isset($_REQUEST["plan_type"])){$_SESSION["plan_type"]=$_REQUEST["plan_type"];}else{if (isset($_SESSION["plan_type"])){$_REQUEST["plan_type"]=$_SESSION["plan_type"];}}
if (isset($_REQUEST["all_nets"])){$_SESSION["all_nets"]=$_REQUEST["all_nets"];}else{if (isset($_SESSION["all_nets"])){$_REQUEST["all_nets"]=$_SESSION["all_nets"];}}





!isset($_REQUEST["tn_rmkk"]) ? $_REQUEST["tn_rmkk"]=0: null;
!isset($_REQUEST["tn_mkk"]) ? $_REQUEST["tn_mkk"]=0: null;
!isset($_REQUEST["plan_type"]) ? $_REQUEST["plan_type"]=1: null;
!isset($_REQUEST["all_nets"]) ? $_REQUEST["all_nets"]=0: null;

if (isset($_REQUEST["calendar_years"]))
{


if ($_REQUEST["calendar_years"]!="")
{

	$_SESSION["calendar_years"]=$_REQUEST["calendar_years"];
	$_SESSION["tn_rmkk"]=$_REQUEST["tn_rmkk"];
	$_SESSION["tn_mkk"]=$_REQUEST["tn_mkk"];
	$_SESSION["plan_type"]=$_REQUEST["plan_type"];
	$_SESSION["all_nets"]=$_REQUEST["all_nets"];

	$sql=rtrim(file_get_contents('sql/negot_proc.sql'));
	$sql_meets=rtrim(file_get_contents('sql/negot_proc_meets.sql'));
	$sql_total=rtrim(file_get_contents('sql/negot_proc_total.sql'));
	$params=array(
		':y'=>$_REQUEST["calendar_years"],
		':plan_type'=>$_REQUEST["plan_type"],
		':all_nets'=>$_REQUEST["all_nets"],
		':tn_rmkk'=>$_REQUEST["tn_rmkk"],
		':tn_mkk'=>$_REQUEST["tn_mkk"],
		':tn'=>$tn
	);
	$sql=stritr($sql,$params);
	$sql_meets=stritr($sql_meets,$params);
	$sql_total=stritr($sql_total,$params);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data_meets = $db->getAll($sql_meets, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data_total = $db->getAll($sql_total, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('negot_proc', $data);
	$smarty->assign('negot_proc_meets', $data_meets);
	$smarty->assign('negot_proc_total', $data_total);

	$file_list=array();

	foreach ($data as $k=>$v)
	{
		$d1="nets_files/".$_REQUEST["calendar_years"]."/";
		$d2=$d1.$v["id_net"]."/";
		$d3=$d2."dus/";
		if (is_dir($d3))
		{
		//echo $d3;
		if ($handle = opendir($d3)) {
			while (false !== ($file = readdir($handle)))
			{
				if ($file != "." && $file != "..") {$file_list[] = array("id_net"=>$v["id_net"],"path"=>$d3,"file"=>$file);}
			}
			closedir($handle);
		}
		//echo "<br>";
		}
	}
	$smarty->assign("file_list_dus", $file_list);
}
}

$sql=rtrim(file_get_contents('sql/calendar_years.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_years', $data);

$sql=rtrim(file_get_contents('sql/list_rmkk.sql'));
$params=array(':tn'=>$tn);
$sql=stritr($sql,$params);
$list_rmkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_rmkk', $list_rmkk);

$sql=rtrim(file_get_contents('sql/list_mkk.sql'));
$params=array(':tn'=>$tn);
$sql=stritr($sql,$params);
$list_mkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_mkk', $list_mkk);

$smarty->display('kk_start.html');
$smarty->display('negot_proc.html');
$smarty->display('kk_end.html');

?>