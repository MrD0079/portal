<?
ses_req();
audit("открыл invoice_reestr_up","invoice_reestr_up");

InitRequestVar("tn_rmkk",0);
InitRequestVar("tn_mkk",0);
InitRequestVar("sd",$_REQUEST["month_list"]);
InitRequestVar("ed",$_REQUEST["month_list"]);
InitRequestVar("okfm","all");
InitRequestVar("oktm","all");

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"])&&isset($_REQUEST["key"]))
{
	foreach ($_REQUEST["key"] as $k=>$v)
	{
		Table_Update ("invoice_reestr_up", $v, $_REQUEST["data"][$k]);
	}
}

if (isset($_FILES['files']))
{
	foreach($_FILES['files']['name'] as $k=>$v)
	{
		if
		(
			is_uploaded_file($_FILES['files']['tmp_name'][$k])
		)
		{
			$a=pathinfo($_FILES['files']['name'][$k]);
			$fn=get_new_file_id().'_'.translit($_FILES['files']['name'][$k]);
			$vals=array('fn'=>$fn);
			Table_Update('invoice_reestr_up', $_REQUEST["key"][$k],$vals);
			move_uploaded_file($_FILES['files']['tmp_name'][$k], 'files/'.$fn);
		}
	}
}

function getTable(/*$payer*//*,$invoice_sended*/)
{
	global $db, $tn, $smarty;
	$sql=rtrim(file_get_contents('sql/invoice_reestr_up.sql'));
	/*$sql_detail=rtrim(file_get_contents('sql/invoice_reestr_up_detail.sql'));
	$sql_files=rtrim(file_get_contents('sql/invoice_files.sql'));
	$sql_acts=rtrim(file_get_contents('sql/invoice_acts.sql'));*/
	$params=array(
		':sd'=>"'".$_REQUEST["sd"]."'",
		':ed'=>"'".$_REQUEST["ed"]."'",
		':okfm'=>"'".$_REQUEST["okfm"]."'",
		':oktm'=>"'".$_REQUEST["oktm"]."'",
		':tn_rmkk'=>$_REQUEST["tn_rmkk"],
		':tn_mkk'=>$_REQUEST["tn_mkk"],
		':tn'=>$tn
	);
	$sql=stritr($sql,$params);
	//echo $sql;
	$invoices = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	/*foreach ($invoices as $k=>$v)
	{
		//echo $v["id_net"]."-".$v["my"]."<br>";
		$params[":invoice"]=$v["id"];
		$invoices[$k]["detail"] = $db->getAll(stritr($sql_detail,$params), null, null, null, MDB2_FETCHMODE_ASSOC);
		$invoices[$k]["files"] = $db->getAll(stritr($sql_files,$params), null, null, null, MDB2_FETCHMODE_ASSOC);
		$invoices[$k]["acts"] = $db->getAll(stritr($sql_acts,$params), null, null, null, MDB2_FETCHMODE_ASSOC);
	}*/
	//print_r($invoices);
	//$smarty->assign('invoice', $invoices);
	//$smarty->assign('fin_report_total', $invoices_total);
	return $invoices;
}

if (isset($_REQUEST["generate"]))
{
	$invoices_all = getTable(/*$_REQUEST["payer"]*//*,$_REQUEST["invoice_sended"]*/);
	$smarty->assign('invoice', $invoices_all);
}


$sql=rtrim(file_get_contents('sql/distr_prot_di_kk.sql'));
$p = array(":dpt_id" => $_SESSION["dpt_id"],':tn'=>$tn);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('payer', $data);

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$sql=rtrim(file_get_contents('sql/nets.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);

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

$sql=rtrim(file_get_contents('sql/urlic.sql'));
$list_urlic = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_urlic', $list_urlic);

isset($_REQUEST["print"]) ? $print = $_REQUEST["print"] : $print = null;
isset($_REQUEST["format"]) ? $format = $_REQUEST["format"] : $format = null;
/*if (isset($_REQUEST["send_invoices"]))
{
	$_REQUEST["print"] = 1;
	$_REQUEST["format"] = 1;
	foreach ($invoices_all as $k => $v)
	{
		$v["invoice_sended"]==0 ? $payers_list[$v["payer"]]["name"]=$v["payer_name"] : null;
		$v["invoice_sended"]==0 ? $payers_list[$v["payer"]]["mail"]=$v["invoice_mail"] : null;
	}
	foreach ($payers_list as $k => $v)
	{
		$invoices = getTable($k,'no');
		$smarty->assign('invoice', $invoices);
		$table = $smarty->fetch('invoice_reestr_up_table.html');
		$fn = get_new_file_id().".xls";
		file_put_contents("files/invoices".$fn, $table);
		//$subj="Реестр счетов для оплаты, информативно"." PAYER(ONLY FOR TEST): ".$v["name"]." MAIL: ".$v["mail"];
		$subj="Реестр счетов для оплаты, информативно";
                send_mail($v["mail"],$subj,$subj,["files/invoices".$fn]);
	}
	foreach ($invoices_all as $k => $v)
	{
		$v["invoice_sended"]==0 ? Table_Update ("invoice", array("id"=>$v["id"]), array("invoice_sended"=>1)) : null;
		$v["invoice_sended"]==0 ? $invoices_all[$k]["invoice_sended"]=1 : null;
	}
}*/
$_REQUEST["print"] = $print;
$_REQUEST["format"] = $format;
isset($invoices_all) ? $smarty->assign('invoice', $invoices_all) : null;
$smarty->display('kk_start.html');
$smarty->display('invoice_reestr_up.html');
$smarty->display('kk_end.html');

?>