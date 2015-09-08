<?php

//audit("вошел в список сетей");
//ses_req();

InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("ok_ts",1);
InitRequestVar("ok_chief",1);

if (isset($_REQUEST["save"]))
{
	$table_name = 'hot_aug_tp_select';
	if (isset($_REQUEST["ok2"]))
	{
		foreach($_REQUEST["ok2"] as $k=>$v)
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
	$table_name = 'hot_aug_action_nakl';
	if (isset($_REQUEST["ok1"]))
	{
		foreach($_REQUEST["ok1"] as $k=>$v)
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
	$table_name = 'hot_aug_action_nakl';
	if (isset($_REQUEST["date1"]))
	{
		foreach($_REQUEST["date1"] as $k=>$v)
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
	$table_name = 'hot_aug_tp_select';
	if (isset($_REQUEST["date2"]))
	{
		foreach($_REQUEST["date2"] as $k=>$v)
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


	$table_name = 'hot_aug_tp_select';
	if (isset($_REQUEST["text2"]))
	{
		foreach($_REQUEST["text2"] as $k=>$v)
		{
			foreach($v as $k1=>$v1)
			{
				foreach($v1 as $k2=>$v2)
				{
					$keys = array('tp_kod'=>$k1);
					$vals = array($k=>$v2);
//echo $k." ".$k1." ".$k2." ".$v." ".$v1." ".$v2."<br>";
					Table_Update ($table_name, $keys, $vals);
				}
			}
		}
	}
	$table_name = 'hot_aug_action_nakl';
	if (isset($_REQUEST["text1"]))
	{
		foreach($_REQUEST["text1"] as $k=>$v)
		{
			foreach($v as $k1=>$v1)
			{
				foreach($v1 as $k2=>$v2)
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



	$table_name = 'hot_aug_files';
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
	if (isset($_REQUEST["text_files"]))
	{
		foreach($_REQUEST["text_files"] as $k=>$v)
		{
			foreach($v as $k1=>$v1)
			{
				foreach($v1 as $k2=>$v2)
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


$params=array(':dpt_id' => $_SESSION["dpt_id"],
	':tn'=>$tn,
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

	$sql=rtrim(file_get_contents("sql/hot_aug_giveup_".$i.".sql"));
	$sql=stritr($sql,$params);
	//echo $sql;
	$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	//print_r($list);
	$smarty->assign("list_".$i, $list);

	$sql_total=rtrim(file_get_contents("sql/hot_aug_giveup_".$i."_total.sql"));
	$sql_total=stritr($sql_total,$params);
	//echo $sql_total;
	$list_total = $db->getAll($sql_total, null, null, null, MDB2_FETCHMODE_ASSOC);
	//print_r($list_total);
	$smarty->assign("list_".$i."_total", $list_total);

	$sql_total=rtrim(file_get_contents("sql/hot_aug_giveup_".$i."_total.sql"));
	$sql_total=stritr($sql_total,$params);
	//echo $sql_total;
	$list_total = $db->getAll($sql_total, null, null, null, MDB2_FETCHMODE_ASSOC);
	//print_r($list_total);
	$smarty->assign("list_".$i."_total_itogi", $list_total);
}

for ($i=1;$i<=2;$i++)
{
	$d1=array();
	$params[':tp_kat']=$i;
	$sql=rtrim(file_get_contents('sql/hot_aug_giveup_files.sql'));
	$sql=stritr($sql,$params);
	$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	if (isset($d))
	{
		foreach ($d as $k=>$v)
		{
			$d1[$v["tn"]]["data"][$v["id"]]=$v;
		}
	}
	$sql=rtrim(file_get_contents('sql/hot_aug_giveup_files_total.sql'));
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





$smarty->display('hot_aug_giveup.html');



?>