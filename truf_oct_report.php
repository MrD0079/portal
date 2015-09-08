<?php

//audit("вошел в список сетей");

InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list","");
InitRequestVar("ok_traid",1);
InitRequestVar("pt",1);

if (isset($_REQUEST["save"]))
{
	$table_name = 'truf_oct_tp_select';
	if (isset($_REQUEST["ok2"]))
	{
		foreach($_REQUEST["ok2"] as $k=>$v)
		{
			foreach($v as $k1=>$v1)
			{
				if ($v1!="")
				{
					$keys = array('tp_kod'=>$k1);
					$vals = array($k=>$v1);
//echo $k." ".$k1." ".$k2." ".$v." ".$v1." ".$v2."<br>";
					Table_Update ($table_name, $keys, $vals);
				}
			}
		}
	}
	$table_name = 'truf_oct_tp_select';
	if (isset($_REQUEST["text2"]))
	{
		foreach($_REQUEST["text2"] as $k=>$v)
		{
			foreach($v as $k1=>$v1)
			{
				$keys = array('tp_kod'=>$k1);
				$vals = array($k=>$v1);
//echo $k." ".$k1." ".$k2." ".$v." ".$v1." ".$v2."<br>";
				Table_Update ($table_name, $keys, $vals);
			}
		}
	}
	$table_name = 'truf_oct_tp_select';
	if (isset($_REQUEST["fakt_bonus"]))
	{
		foreach ($_REQUEST["fakt_bonus"] as $key => $val)
		{
			if ($val!=null)
			{
				$keys = array('tp_kod'=>$key);
				$values = array('fakt_bonus'=>$val);
				Table_Update ($table_name, $keys, $values);
			}
		}
	}
	$table_name = 'truf_oct_files';
	if (isset($_REQUEST["ok_files"]))
	{
		foreach($_REQUEST["ok_files"] as $k=>$v)
		{
			foreach($v as $k1=>$v1)
			{
				if ($v1!="")
				{
					$keys = array('id'=>$k1);
					$vals = array($k=>$v1);
//echo $k." ".$k1." ".$k2." ".$v." ".$v1." ".$v2."<br>";
					Table_Update ($table_name, $keys, $vals);
				}
			}
		}
	}
	if (isset($_REQUEST["text_files"]))
	{
		foreach($_REQUEST["text_files"] as $k=>$v)
		{
			foreach($v as $k1=>$v1)
			{
				$keys = array('id'=>$k1);
				$vals = array($k=>$v1);
//echo $k." ".$k1." ".$k2." ".$v." ".$v1." ".$v2."<br>";
				Table_Update ($table_name, $keys, $vals);
			}
		}
	}
}


//ses_req();

$params=array(':dpt_id' => $_SESSION["dpt_id"],
	':tn'=>$tn,
	':ok_traid' => $_REQUEST["ok_traid"],
	':eta_list' => "'".$_REQUEST["eta_list"]."'",
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
	':pt'=>$_REQUEST["pt"]
);

$sql = rtrim(file_get_contents('sql/exp_list_from_parent_only_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_only_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_only_ts', $exp_list_only_ts);

$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_without_ts', $exp_list_without_ts);

$sql = rtrim(file_get_contents('sql/truf_oct_report_eta_list.sql'));
$sql=stritr($sql,$params);
$eta_list = $db->getCol($sql);
$smarty->assign('eta_list', $eta_list);


$sql=rtrim(file_get_contents("sql/truf_oct_report.sql"));
$sql=stritr($sql,$params);
//echo $sql;
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//print_r($list);
$smarty->assign("list", $list);


$sql_total=rtrim(file_get_contents("sql/truf_oct_report_total.sql"));
$sql_total=stritr($sql_total,$params);
//echo $sql_total;
$list_total = $db->getAll($sql_total, null, null, null, MDB2_FETCHMODE_ASSOC);
//print_r($list_total);
$smarty->assign("list_total", $list_total);

$params[":ok_traid"]=3;

$sql_total=rtrim(file_get_contents("sql/truf_oct_report_total.sql"));
$sql_total=stritr($sql_total,$params);
//echo $sql_total;
$list_total = $db->getAll($sql_total, null, null, null, MDB2_FETCHMODE_ASSOC);
//print_r($list_total);
$smarty->assign("list_total_itogi", $list_total);


$d1=array();
$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn);
$params[':exp_list_without_ts'] = $_REQUEST["exp_list_without_ts"];
$params[':exp_list_only_ts'] = $_REQUEST["exp_list_only_ts"];
$params[':ok_traid'] = $_REQUEST["ok_traid"];
$sql=rtrim(file_get_contents('sql/truf_oct_files.sql'));
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

if (isset($d))
{
foreach ($d as $k=>$v)
{
$d1[$v["tn"]]["data"][$v["id"]]=$v;
}
}

$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn);
$params[':exp_list_without_ts'] = $_REQUEST["exp_list_without_ts"];
$params[':exp_list_only_ts'] = $_REQUEST["exp_list_only_ts"];
$params[':ok_traid'] = $_REQUEST["ok_traid"];
$sql=rtrim(file_get_contents('sql/truf_oct_files_total.sql'));
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

if (isset($d))
{
foreach ($d as $k=>$v)
{
$d1[$v["tn"]]["data_total"]=$v;
}
}

if (isset($d1))
{
$smarty->assign('file_list', $d1);
}


$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn);
$params[':exp_list_without_ts'] = $_REQUEST["exp_list_without_ts"];
$params[':exp_list_only_ts'] = $_REQUEST["exp_list_only_ts"];
$params[':ok_traid'] = $_REQUEST["ok_traid"];
$sql=rtrim(file_get_contents('sql/truf_oct_files_total_total.sql'));
$sql=stritr($sql,$params);
$d = $db->getOne($sql);
$smarty->assign('file_list_total', $d);



$smarty->display('truf_oct_report.html');

//ses_req();


?>