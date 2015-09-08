<?php
//audit("вошел в список сетей");
//ses_req();

InitRequestVar("selected_tp",'');
InitRequestVar("eta_list","");
//!isset($_REQUEST["selected_tp"]) ? $_REQUEST["selected_tp"]=0: null;

$table_name = "fartuk_action_nakl";
if (isset($_REQUEST["add"]))
{
	if (isset($_REQUEST["keys"]))
	{
		foreach ($_REQUEST["keys"] as $key => $val)
		{
			$keys = array('h_custcode_kodtt_invoiceno_dt'=>$key);
			if ($val=='true')
			{
				Table_Update ($table_name, $keys, $keys);
			}
			else
			{
				Table_Update ($table_name, $keys, null);
			}
		}
	}
	if (isset($_REQUEST["data"]))
	{
		foreach ($_REQUEST["data"] as $key => $val)
		{
			$keys = array('h_custcode_kodtt_invoiceno_dt'=>$key);
			$val["bonus_dt"]=OraDate2MDBDate($val["bonus_dt"]);
			Table_Update ($table_name, $keys, $val);
		}
	}
}

if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["data_total"]))
	{
		foreach ($_REQUEST["data_total"] as $key => $val)
		{
			$keys = array('h_custcode_kodtt_invoiceno_dt'=>$key);
			Table_Update ($table_name, $keys, $val);
		}
	}
}

if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $key => $val)
	{
		$keys = array('h_custcode_kodtt_invoiceno_dt'=>$key);
		Table_Update ($table_name, $keys, null);
	}
}

$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn);

$sql = rtrim(file_get_contents('sql/fartuk_process_eta_list.sql'));
$sql=stritr($sql,$params);
$eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('eta_list', $eta_list);

if (isset($_REQUEST["selected_tp"]))
{
$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp'=>"'".$_REQUEST["selected_tp"]."'",':eta_list' => "'".$_REQUEST["eta_list"]."'");
$sql = rtrim(file_get_contents('sql/fartuk_process_nakl.sql'));
$sql=stritr($sql,$params);
//echo $sql;
$nakl_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nakl_list', $nakl_list);
}

$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp'=>0,':eta_list' => "'".$_REQUEST["eta_list"]."'");

$sql=rtrim(file_get_contents('sql/fartuk_process_tp.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp', $tp);

$sql = rtrim(file_get_contents('sql/fartuk_process_nakl.sql'));
$sql=stritr($sql,$params);
$nakl_list_all = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nakl_list_all', $nakl_list_all);

$sql=rtrim(file_get_contents('sql/fartuk_process_nakl_total.sql'));
$sql=stritr($sql,$params);
$nakl_list_all_total = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nakl_list_all_total', $nakl_list_all_total);

$smarty->display('fartuk_process.html');
?>