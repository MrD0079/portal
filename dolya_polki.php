<?

//ses_req();
audit("открыл dolya_polki","fin_plan");


if (isset($_REQUEST["nets"])){$_SESSION["nets"]=$_REQUEST["nets"];}else{if (isset($_SESSION["nets"])){$_REQUEST["nets"]=$_SESSION["nets"];}}
if (isset($_REQUEST["calendar_years"])){$_SESSION["calendar_years"]=$_REQUEST["calendar_years"];}else{if (isset($_SESSION["calendar_years"])){$_REQUEST["calendar_years"]=$_SESSION["calendar_years"];}}
if (isset($_REQUEST["tn_rmkk"])){$_SESSION["tn_rmkk"]=$_REQUEST["tn_rmkk"];}else{if (isset($_SESSION["tn_rmkk"])){$_REQUEST["tn_rmkk"]=$_SESSION["tn_rmkk"];}}
if (isset($_REQUEST["tn_mkk"])){$_SESSION["tn_mkk"]=$_REQUEST["tn_mkk"];}else{if (isset($_SESSION["tn_mkk"])){$_REQUEST["tn_mkk"]=$_SESSION["tn_mkk"];}}
if (isset($_REQUEST["orderby"])){$_SESSION["orderby"]=$_REQUEST["orderby"];}else{if (isset($_SESSION["orderby"])){$_REQUEST["orderby"]=$_SESSION["orderby"];}}



!isset($_REQUEST["tn_rmkk"]) ? $_REQUEST["tn_rmkk"]=0: null;
!isset($_REQUEST["tn_mkk"]) ? $_REQUEST["tn_mkk"]=0: null;
!isset($_REQUEST["nets"]) ? $_REQUEST["nets"]=0: null;
//!isset($_REQUEST["orderby"]) ? $_REQUEST["orderby"]=0: null;


$sql=rtrim(file_get_contents('sql/calendar_years.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_years', $data);

$sql=rtrim(file_get_contents('sql/list_rmkk.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$list_rmkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_rmkk', $list_rmkk);

$sql=rtrim(file_get_contents('sql/list_mkk.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$list_mkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_mkk', $list_mkk);

$sql=rtrim(file_get_contents('sql/nets.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);

if (isset($_REQUEST["calendar_years"]))
{
	$_SESSION["calendar_years"]=$_REQUEST["calendar_years"];
	$_SESSION["nets"]=$_REQUEST["nets"];
	$_SESSION["tn_rmkk"]=$_REQUEST["tn_rmkk"];
	$_SESSION["tn_mkk"]=$_REQUEST["tn_mkk"];
//	$_SESSION["orderby"]=$_REQUEST["orderby"];

	$sql1=rtrim(file_get_contents('sql/dolya_polki_1.sql'));
	$sql2=rtrim(file_get_contents('sql/dolya_polki_2.sql'));
	$sqlo=rtrim(file_get_contents('sql/dolya_polki_2_order_by_sales.sql'));
	$sql1_total=rtrim(file_get_contents('sql/dolya_polki_1_total.sql'));
	$sql2_total=rtrim(file_get_contents('sql/dolya_polki_2_total.sql'));
	$params=array(
		':y'=>$_REQUEST["calendar_years"],
		':net'=>$_REQUEST["nets"],
//		':orderby'=>$_REQUEST["orderby"],
		':tn_rmkk'=>$_REQUEST["tn_rmkk"],
		':tn_mkk'=>$_REQUEST["tn_mkk"],
		':tn'=>$tn
	);
	$sql1 = stritr($sql1, $params);
	$sql2=stritr($sql2,$params);
	$sqlo=stritr($sqlo,$params);
	$sql1_total=stritr($sql1_total,$params);
	$sql2_total=stritr($sql2_total,$params);
	//echo $sql;
	$data1 = $db->getAll($sql1, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data2 = $db->getAll($sql2, null, null, null, MDB2_FETCHMODE_ASSOC);
	$datao = $db->getAll($sqlo, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data1_total = $db->getAll($sql1_total, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data2_total = $db->getAll($sql2_total, null, null, null, MDB2_FETCHMODE_ASSOC);
//print_r($data);



foreach ($data1 as $k=>$v)
{
$h[$v["prop_id"]]=$v["proportion_name"];
$d[$v["id_net"]]["net_name"]=$v["net_name"];
$d[$v["id_net"]]["data_y"][$v["y"]]=$v["y"];
$d[$v["id_net"]]["data_prop"][$v["prop_id"]]["proportion_name"]=$v["proportion_name"];
$d[$v["id_net"]]["data_prop"][$v["prop_id"]]["data"][$v["y"]]=$v["perc"];
}


foreach ($data1 as $k=>$v)
{
$d3_total[$v["prop_id"]][$v["y"]][$v["id_net"]]=$v["perc"];
}


//print_r($d3_total);


foreach ($data1_total as $k=>$v)
{
$d1_total["data_y"][$v["y"]]=$v["y"];
$d1_total["data_perc"][$v["prop_id"]][$v["y"]]=$v["perc"];
}


//print_r($d1_total);



foreach ($data2 as $k=>$v)
{
$d[$v["id_net"]]["data_sales"][$v["y"]]=$v["sales"];
//$dd[$v["id_net"]]=$d[$v["id_net"]];
//$dd[$v["id_net"]]["data_sales"][$v["y"]]=$v["sales"];
}


foreach ($datao as $k=>$v)
{
$dd[$v["id_net"]]=$d[$v["id_net"]];
}



if (isset($_REQUEST["orderby"]))
{
//ses_req();
if ($_REQUEST["orderby"]==1)
{
$d=$dd;
}
}


foreach ($data2_total as $k=>$v)
{
$d2_total[$v["y"]]=$v["sales"];
}




//print_r($d2);

/*
foreach ($data_total as $k=>$v)
{
$d_total[0]["data_y"][$v["y"]][$v["my"]]["total"]=$v["total"];
$d_total[0]["data_my"][$v["my"]][$v["y"]]["total"]=$v["total"];
}
*/
//print_r($d_total);





	isset($h)?$smarty->assign('h', $h):null;
	isset($d1_total)?$smarty->assign('d1_total', $d1_total):null;
	isset($d2_total)?$smarty->assign('d2_total', $d2_total):null;
	isset($d3_total)?$smarty->assign('d3_total', $d3_total):null;
	isset($d)?$smarty->assign('dolya_polki', $d):null;
//	$smarty->assign('dolya_polki_total', $d_total);





}

$smarty->display('kk_start.html');
$smarty->display('dolya_polki.html');
$smarty->display('kk_end.html');

?>