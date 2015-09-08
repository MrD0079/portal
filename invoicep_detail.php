<?
audit("открыл invoicep_detail","invoicep_detail");

if (isset($_REQUEST["link"])&&isset($_REQUEST["upd"]))
{
	$k=array("id"=>$_REQUEST["id"]);
	$v=$_REQUEST["upd"];
	Table_Update ("invoice", $k, $v);
}

if (isset($_REQUEST["link"])&&isset($_REQUEST["ok1"]))
{
	foreach ($_REQUEST["ok1"] as $k=>$v)
	{
		$keys["statya"]=$k;
		$keys["invoice"]=/*$invoice["id"]*/$_REQUEST["id"];
		if ($v!="")
		{
			if ($v==1)
			{
				$vals=array("summa"=>str_replace(",", ".", $_REQUEST["summa"][$k]));
			}
			else
			{
				$vals=null;
			}
			//print_r($keys);
			//print_r($vals);
			Table_Update ("invoice_detail", $keys, $vals);
		}
	}
}

InitRequestVar("sd",$_SESSION["month_list"]);
InitRequestVar("ed",$_SESSION["month_list"]);

$sql=rtrim(file_get_contents('sql/invoice.sql'));
$params=array(':invoice'=>$_REQUEST["id"]);
$sql=stritr($sql,$params);
$invoice = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign("invoice", $invoice);

$sql=rtrim(file_get_contents('sql/invoicep_detail.sql'));
$sqlt=rtrim(file_get_contents('sql/invoicep_detail_total.sql'));
$params=array(
	':sd'=>"'".$_REQUEST["sd"]."'",
	':ed'=>"'".$_REQUEST["ed"]."'",
	':invoice'=>$_REQUEST["id"],
	":plan_type" => 4,
	':net'=>$invoice["id_net"],
	':tn'=>$tn
	);
$sql=stritr($sql,$params);
$sqlt=stritr($sqlt,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$datat = $db->getRow($sqlt, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign("invoice_detail", $data);
$smarty->assign("invoice_detail_total", $datat);
//echo $sqlt;
//print_r($data);

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$sql=rtrim(file_get_contents('sql/distr_prot_di.sql'));
$p = array(":dpt_id" => $_SESSION["dpt_id"],':tn'=>$tn);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('payer', $data);

$smarty->display('kk_start.html');
$smarty->display('invoicep_detail.html');
$smarty->display('kk_end.html');

?>