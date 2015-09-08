<?php

//audit("вошел в список сетей");
//ses_req();


if (isset($_REQUEST["save_a"]))
{
	$table_name = 'val_mart_tp_select';
	if (isset($_REQUEST["ok"]))
	{
		foreach($_REQUEST["ok"] as $k=>$v)
		{
			foreach($v as $k1=>$v1)
			{
				foreach($v1 as $k2=>$v2)
				{
					if ($v2!="")
					{
						$keys = array('tp_kod'=>$k1);
						$vals = array($k=>$v2);
//echo $k." ".$k1." ".$k2." ".$v." ".$v1." ".$v2."<br>";
						Table_Update ($table_name, $keys, $vals);
					}
				}
			}
		}
	}

	if (isset($_REQUEST["date"]))
	{
		foreach($_REQUEST["date"] as $k=>$v)
		{
			foreach($v as $k1=>$v1)
			{
				foreach($v1 as $k2=>$v2)
				{
					if ($v2!="")
					{
						$keys = array('tp_kod'=>$k1);
						$vals = array($k=>OraDate2MDBDate($v2));
//echo $k." ".$k1." ".$k2." ".$v." ".$v1." ".$v2."<br>";
						Table_Update ($table_name, $keys, $vals);
					}
				}
			}
		}
	}
	if (isset($_REQUEST["fakt_bonus"]))
	{
		foreach ($_REQUEST["fakt_bonus"] as $key => $val)
		{
			foreach($val as $k1=>$v1)
			{
				$keys = array('tp_kod'=>$key);
				$values = array('fakt_bonus'=>str_replace(",", ".", $v1));
				Table_Update ($table_name, $keys, $values);
			}
		}
	}
	if (isset($_REQUEST["ok_tn"]))
	{
		foreach($_REQUEST["ok_tn"] as $k=>$v)
		{
			foreach($v as $k1=>$v1)
			{
				foreach($v1 as $k2=>$v2)
				{
					if ($v2!="")
					{
						$keys = array('tp_kod'=>$k1);
						$vals = array($k=>$v2);
//echo $k." ".$k1." ".$k2." ".$v." ".$v1." ".$v2."<br>";
						Table_Update ($table_name, $keys, $vals);
					}
				}
			}
		}
	}
}
if (isset($_REQUEST["save_b"]))
{
	$table_name = 'val_mart_action_nakl';
	if (isset($_REQUEST["ok"]))
	{
		foreach($_REQUEST["ok"] as $k=>$v)
		{
			foreach($v as $k1=>$v1)
			{
				foreach($v1 as $k2=>$v2)
				{
					if ($v2!="")
					{
						$keys = array(
							'tp_kod'=>$k1,
							'nakl'=>$k2
						);
						$vals = array($k=>$v2);
//echo $k." ".$k1." ".$k2." ".$v." ".$v1." ".$v2."<br>";
						Table_Update ($table_name, $keys, $vals);
					}
				}
			}
		}
	}

	if (isset($_REQUEST["date"]))
	{
		foreach($_REQUEST["date"] as $k=>$v)
		{
			foreach($v as $k1=>$v1)
			{
				foreach($v1 as $k2=>$v2)
				{
					if ($v2!="")
					{
						$keys = array(
							'tp_kod'=>$k1,
							'nakl'=>$k2
						);
						$vals = array($k=>OraDate2MDBDate($v2));
//echo $k." ".$k1." ".$k2." ".$v." ".$v1." ".$v2."<br>";
						Table_Update ($table_name, $keys, $vals);
					}
				}
			}
		}
	}

	if (isset($_REQUEST["ok_tn"]))
	{
		foreach($_REQUEST["ok_tn"] as $k=>$v)
		{
			foreach($v as $k1=>$v1)
			{
				foreach($v1 as $k2=>$v2)
				{
					if ($v2!="")
					{
						$keys = array(
							'tp_kod'=>$k1,
							'nakl'=>$k2
						);
						$vals = array($k=>$v2);
//echo $k." ".$k1." ".$k2." ".$v." ".$v1." ".$v2."<br>";
						Table_Update ($table_name, $keys, $vals);
					}
				}
			}
		}
	}
}





if (isset($_REQUEST["save_a"])||isset($_REQUEST["save_b"]))
{
	$table_name = 'val_mart_files';
	if (isset($_REQUEST["ok_files"]))
	{
		foreach($_REQUEST["ok_files"] as $k=>$v)
		{
			foreach($v as $k1=>$v1)
			{
				foreach($v1 as $k2=>$v2)
				{
					if ($v2!="")
					{
						$keys = array('id'=>$k1);
						$vals = array($k=>$v2);
//echo $k." ".$k1." ".$k2." ".$v." ".$v1." ".$v2."<br>";
						Table_Update ($table_name, $keys, $vals);
					}
				}
			}
		}
	}
}





if (isset($_REQUEST["exp_list_without_ts"])){$_SESSION["exp_list_without_ts"]=$_REQUEST["exp_list_without_ts"];}else{if (isset($_SESSION["exp_list_without_ts"])){$_REQUEST["exp_list_without_ts"]=$_SESSION["exp_list_without_ts"];}}
if (isset($_REQUEST["exp_list_only_ts"])){$_SESSION["exp_list_only_ts"]=$_REQUEST["exp_list_only_ts"];}else{if (isset($_SESSION["exp_list_only_ts"])){$_REQUEST["exp_list_only_ts"]=$_SESSION["exp_list_only_ts"];}}
//if (isset($_REQUEST["giveup"])){$_SESSION["giveup"]=$_REQUEST["giveup"];}else{if (isset($_SESSION["giveup"])){$_REQUEST["giveup"]=$_SESSION["giveup"];}}
//if (isset($_REQUEST["giveup_check"])){$_SESSION["giveup_check"]=$_REQUEST["giveup_check"];}else{if (isset($_SESSION["giveup_check"])){$_REQUEST["giveup_check"]=$_SESSION["giveup_check"];}}
if (isset($_REQUEST["ok_traid"])){$_SESSION["ok_traid"]=$_REQUEST["ok_traid"];}else{if (isset($_SESSION["ok_traid"])){$_REQUEST["ok_traid"]=$_SESSION["ok_traid"];}}
if (isset($_REQUEST["ok_ts"])){$_SESSION["ok_ts"]=$_REQUEST["ok_ts"];}else{if (isset($_SESSION["ok_ts"])){$_REQUEST["ok_ts"]=$_SESSION["ok_ts"];}}
if (isset($_REQUEST["ok_chief"])){$_SESSION["ok_chief"]=$_REQUEST["ok_chief"];}else{if (isset($_SESSION["ok_chief"])){$_REQUEST["ok_chief"]=$_SESSION["ok_chief"];}}

!isset($_REQUEST["exp_list_without_ts"]) ? $_REQUEST["exp_list_without_ts"]=0: null;
!isset($_REQUEST["exp_list_only_ts"]) ? $_REQUEST["exp_list_only_ts"]=0: null;
!isset($_REQUEST["giveup"]) ? $_REQUEST["giveup"]=0: null;
!isset($_REQUEST["giveup_check"]) ? $_REQUEST["giveup_check"]=0: null;
!isset($_REQUEST["ok_traid"]) ? $_REQUEST["ok_traid"]=1: null;
!isset($_REQUEST["ok_ts"]) ? $_REQUEST["ok_ts"]=1: null;
!isset($_REQUEST["ok_chief"]) ? $_REQUEST["ok_chief"]=1: null;





if ($_REQUEST["giveup"]==1)
{
$_REQUEST["ok_traid"]=2;
}




$_SESSION["exp_list_without_ts"]=$_REQUEST["exp_list_without_ts"];
$_SESSION["exp_list_only_ts"]=$_REQUEST["exp_list_only_ts"];
//$_SESSION["giveup"]=$_REQUEST["giveup"];
//$_SESSION["giveup_check"]=$_REQUEST["giveup_check"];
$_SESSION["ok_traid"]=$_REQUEST["ok_traid"];
$_SESSION["ok_ts"]=$_REQUEST["ok_ts"];
$_SESSION["ok_chief"]=$_REQUEST["ok_chief"];

	$params=array(':dpt_id' => $_SESSION["dpt_id"],
		':tn'=>$tn,
		':giveup_check' => $_REQUEST["giveup_check"],
		':giveup' => $_REQUEST["giveup"],
		':ok_traid' => $_REQUEST["ok_traid"],
		':ok_ts' => $_REQUEST["ok_ts"],
		':ok_chief' => $_REQUEST["ok_chief"],
		':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
		':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"]
	);

	$sql = rtrim(file_get_contents('sql/exp_list_from_parent_only_ts.sql'));
	$sql=stritr($sql,$params);
	//echo $sql;
	//$exp_list = &$db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
	$exp_list_only_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('exp_list_only_ts', $exp_list_only_ts);

	$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
	$sql=stritr($sql,$params);
	//echo $sql;
	//$exp_list = &$db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
	$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('exp_list_without_ts', $exp_list_without_ts);

for ($i=1;$i<=2;$i++)
{

	$params[':tp_kat']=$i;
	$params[":ok_ts"]=$_REQUEST["ok_ts"];
	$params[":ok_traid"]=$_REQUEST["ok_traid"];

	$sql=rtrim(file_get_contents("sql/val_mart_report_".$i.".sql"));
	$sql=stritr($sql,$params);
	//echo $sql;
	$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	//print_r($list);
	$smarty->assign("list_".$i, $list);


	$sql_total=rtrim(file_get_contents("sql/val_mart_report_".$i."_total.sql"));
	$sql_total=stritr($sql_total,$params);
	//echo $sql_total;
	$list_total = $db->getAll($sql_total, null, null, null, MDB2_FETCHMODE_ASSOC);
	//print_r($list_total);
	$smarty->assign("list_".$i."_total", $list_total);

	if ($_REQUEST["giveup"]==1)
	{
		$params[":ok_ts"]=2;
	}

	$params[":ok_traid"]=2;



	$sql_total=rtrim(file_get_contents("sql/val_mart_report_".$i."_total.sql"));
	$sql_total=stritr($sql_total,$params);
	//echo $sql_total;
	$list_total = $db->getAll($sql_total, null, null, null, MDB2_FETCHMODE_ASSOC);
	//print_r($list_total);
	$smarty->assign("list_".$i."_total_itogi", $list_total);



/*
	$sql_total_itogi=rtrim(file_get_contents("sql/val_mart_report_".$i."_total_itogi.sql"));
	$sql_total_itogi=stritr($sql_total_itogi,$params);
	//echo $sql_total;
	$list_total_itogi = $db->getAll($sql_total_itogi, null, null, null, MDB2_FETCHMODE_ASSOC);
	//print_r($tp_total);
	$smarty->assign("list_".$i."_total_itogi", $list_total_itogi);
*/

}






for ($i=1;$i<=2;$i++)
{

$d1=array();
$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp_kat'=>$i);
$params[':exp_list_without_ts'] = $_REQUEST["exp_list_without_ts"];
$params[':exp_list_only_ts'] = $_REQUEST["exp_list_only_ts"];
$sql=rtrim(file_get_contents('sql/val_mart_files.sql'));
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

if (isset($d))
{
foreach ($d as $k=>$v)
{
$d1[$v["tn"]]["data"][$v["id"]]=$v;
}
}

$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp_kat'=>$i);
$params[':exp_list_without_ts'] = $_REQUEST["exp_list_without_ts"];
$params[':exp_list_only_ts'] = $_REQUEST["exp_list_only_ts"];
$sql=rtrim(file_get_contents('sql/val_mart_files_total.sql'));
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
$smarty->assign('file_list_'.$i, $d1);
}

}

$smarty->display('val_mart_report.html');



?>