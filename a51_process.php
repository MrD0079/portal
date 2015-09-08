<?php

audit("a51","a51");
//ses_req();


if (isset($_REQUEST["selected_tp"]))
{
	if ($_REQUEST["selected_tp"]!=null)
	{
		$a=split(',',$_REQUEST["selected_tp"]);
	}
	else
	{
		$a=array(0,0);
	}
}
else
{
	$a=array(0,0);
}





//print_r($a);





if (isset($_REQUEST["save"]))
{
audit("save action_nakl","a51");
	$table_name = "a51_action_nakl";
	if (isset($_REQUEST["selected_changed"]))
	{
		foreach ($_REQUEST["selected_changed"] as $key => $val)
		{
		foreach ($val as $key1 => $val1)
		{
			if ($val1!=null)
			{
				$keys = array(
					'tp_kod'=>$a[0],
					'fio_eta'=>$a[1],
					'nakl'=>$key
				);
				$values = null/*array('selected'=>Bool2Int($val))*/;
				Table_Update ($table_name, $keys, $values);
			}
		}
		}
	}
	if (isset($_REQUEST["ya"]))
	{
		foreach ($_REQUEST["ya"] as $key => $val)
		{
		foreach ($val as $key1 => $val1)
		{
				$keys = array(
					'tp_kod'=>$a[0],
					'fio_eta'=>$a[1],
					'nakl'=>$key
				);
				$values = array('ya'=>$val1);
			Table_Update ($table_name, $keys, $values);
		}
		}
	}
}

$table_name = "a51_action_nakl";
if (isset($_REQUEST["del"]))
{
audit("удалил акционную накладную","a51");
	foreach ($_REQUEST["del"] as $key => $val)
	{
		foreach($val as $k1=>$v1)
		{
		foreach($v1 as $k2=>$v2)
		{
			$keys = array(
				'tp_kod'=>$key,
				'nakl'=>$k1,
				'fio_eta'=>$k2
			);
			$values = null/*array('selected'=>Bool2Int($val))*/;
			Table_Update ($table_name, $keys, $values);
		}
		}
	}
}




$params=array(':tn'=>$tn);


if (isset($_REQUEST["selected_tp"]))
{
	if ($_REQUEST["selected_tp"]!=null)
	{
		$params=array(':tn'=>$tn,':tp'=>$a[0],':eta'=>$a[1],':dpt_id' => $_SESSION["dpt_id"]);
		$sql = rtrim(file_get_contents('sql/a51_process_nakl.sql'));
		$sql=stritr($sql,$params);
		//echo $sql;
		$nakl_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		foreach ($nakl_list as $k=>$v)
		{
			if (isset($v["max_ya"]))
			{
			if ($v["max_ya"]>0)
			{
				for ($i=1;$i<=$v["max_ya"];$i++)
				{
					$nakl_list[$k]["ya"][$i]=$i;
				}
			}
			}
		}
	}
}
if (isset($nakl_list))
{
$smarty->assign('nakl_list', $nakl_list);
}






if (isset($_REQUEST["del_file"]))
{
foreach ($_REQUEST["del_file"] as $k=>$v)
{
$fn=$db->getOne("select fn from a51_files where id=".$k);
unlink("a51_files/".$tn."/".$fn);
$res=$db->query("delete from a51_files where id=".$k);
audit("del file a51_files/".$tn."/".$fn,"a51");
}
}



if (isset($_FILES["new_fn"]))
{
if ($_FILES["new_fn"]["name"]!="")
{
	//ses_req();
	$_REQUEST["new"]["ya_p"]=str_replace(",", ".", $_REQUEST["new"]["ya_p"]);
	$_REQUEST["new"]["ya_kk"]=str_replace(",", ".", $_REQUEST["new"]["ya_kk"]);
	$_REQUEST["new"]["tn"]=$tn;
	$d1="a51_files/".$tn;
	if (!file_exists($d1)) {mkdir($d1);}
	if (is_uploaded_file($_FILES["new_fn"]['tmp_name'])){move_uploaded_file($_FILES["new_fn"]["tmp_name"], $d1."/".translit($_FILES["new_fn"]["name"]));}
	$_REQUEST["new"]["fn"]=translit($_FILES["new_fn"]["name"]);
	if ($_FILES["new_fn"]['error']==0){Table_Update("a51_files",$_REQUEST["new"],$_REQUEST["new"]);}
}
}







$params=array(
	':tn'=>$tn,
	':dpt_id' => $_SESSION["dpt_id"],':exp_list_without_ts' => 0,':exp_list_only_ts' => 0
);
$sql=rtrim(file_get_contents('sql/a51_files.sql'));
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('file_list', $d);





$params=array(
	':tn'=>$tn,
	':dpt_id' => $_SESSION["dpt_id"],':exp_list_without_ts' => 0,':exp_list_only_ts' => 0
);
$sql=rtrim(file_get_contents('sql/a51_process.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp', $tp);

$params=array(':tn'=>$tn,':tp'=>0,':eta'=>0,':dpt_id' => $_SESSION["dpt_id"],':exp_list_without_ts' => 0,':exp_list_only_ts' => 0);
$sql = rtrim(file_get_contents('sql/a51_process_nakl.sql'));
$sql=stritr($sql,$params);
$nakl_list_all = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nakl_list_all', $nakl_list_all);

$params=array(':tn'=>$tn,':tp'=>0,':eta'=>0,':dpt_id' => $_SESSION["dpt_id"],':exp_list_without_ts' => 0,':exp_list_only_ts' => 0);
$sql=rtrim(file_get_contents('sql/a51_process_nakl_total.sql'));
$sql=stritr($sql,$params);
$sql=stritr($sql,$params);
$nakl_list_all_total = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nakl_list_all_total', $nakl_list_all_total);

$smarty->display('a51_process.html');
?>