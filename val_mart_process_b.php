<?php
//audit("вошел в список сетей");
///ses_req();

InitRequestVar("selected_tp",0);
//!isset($_REQUEST["selected_tp"]) ? $_REQUEST["selected_tp"]=0: null;

if (isset($_REQUEST["save"]))
{
	$table_name = "val_mart_action_nakl";
	if (isset($_REQUEST["selected_changed"]))
	{
		foreach ($_REQUEST["selected_changed"] as $key => $val)
		{
			if ($val!=null)
			{
				$keys = array(
					'tp_kod'=>$_REQUEST["selected_tp"],
					'nakl'=>$key
				);
				$values = null/*array('selected'=>Bool2Int($val))*/;
				Table_Update ($table_name, $keys, $values);
			}
		}
	}
	if (isset($_REQUEST["ya"]))
	{
		foreach ($_REQUEST["ya"] as $key => $val)
		{
				$keys = array(
					'tp_kod'=>$_REQUEST["selected_tp"],
					'nakl'=>$key
				);
				$values = array('ya'=>$val);
			Table_Update ($table_name, $keys, $values);
		}
	}
}


$table_name = "val_mart_action_nakl";
if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $key => $val)
	{
		foreach($val as $k1=>$v1)
		{
			$keys = array(
				'tp_kod'=>$key,
				'nakl'=>$k1
			);
			$values = null/*array('selected'=>Bool2Int($val))*/;
			Table_Update ($table_name, $keys, $values);
		}
	}
}


$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn);





if ($_REQUEST["selected_tp"]!=0)
{
$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp'=>$_REQUEST["selected_tp"]);
$sql = rtrim(file_get_contents('sql/val_mart_process_nakl.sql'));
$sql=stritr($sql,$params);
//echo $sql;
$nakl_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach ($nakl_list as $k=>$v)
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
if (isset($nakl_list))
{
$smarty->assign('nakl_list', $nakl_list);
}






if (isset($_REQUEST["del_file"]))
{
foreach ($_REQUEST["del_file"] as $k=>$v)
{
$fn=$db->getOne("select fn from val_mart_files where id=".$k);
unlink("val_mart_files/".$tn."/b/".$fn);
$fn=$db->query("delete from val_mart_files where id=".$k);
}
}


if (isset($_FILES["new_fn"]))
{
if ($_FILES["new_fn"]["name"]!="")
{
	//ses_req();
	$_REQUEST["new"]["tn"]=$tn;
	$d1="val_mart_files/".$tn;
	if (!file_exists($d1)) {mkdir($d1);}
	$d1=$d1."/b";
	if (!file_exists($d1)) {mkdir($d1);}
	if (is_uploaded_file($_FILES["new_fn"]['tmp_name'])){move_uploaded_file($_FILES["new_fn"]["tmp_name"], $d1."/".translit($_FILES["new_fn"]["name"]));}
	$_REQUEST["new"]["fn"]=translit($_FILES["new_fn"]["name"]);
	if ($_FILES["new_fn"]['error']==0){Table_Update("val_mart_files",$_REQUEST["new"],$_REQUEST["new"]);}
}
}


InitRequestVar("pt",1);
//!isset($_REQUEST["pt"]) ? $_REQUEST["pt"]=1: null;



$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp_kat'=>2,':exp_list_without_ts' => 0,':exp_list_only_ts' => 0);
$sql=rtrim(file_get_contents('sql/val_mart_files.sql'));
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//echo $sql;
$smarty->assign('file_list', $d);





$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp_kat'=>2,':pt'=>$_REQUEST["pt"]);
$sql=rtrim(file_get_contents('sql/val_mart_process.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp', $tp);

$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp_kat'=>2,':pt'=>$_REQUEST["pt"]);
$sql=rtrim(file_get_contents('sql/val_mart_process_total.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp_total', $tp);



$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp'=>0,':pt'=>$_REQUEST["pt"]);
$sql = rtrim(file_get_contents('sql/val_mart_process_nakl.sql'));
$sql=stritr($sql,$params);
$nakl_list_all = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nakl_list_all', $nakl_list_all);

$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp'=>0,':pt'=>$_REQUEST["pt"]);
$sql=rtrim(file_get_contents('sql/val_mart_process_nakl_total.sql'));
$sql=stritr($sql,$params);
$sql=stritr($sql,$params);
$nakl_list_all_total = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nakl_list_all_total', $nakl_list_all_total);

$smarty->display('val_mart_process_b.html');
?>