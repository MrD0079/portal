<?php
//audit("вошел в список сетей");
//ses_req();

InitRequestVar("selected_tp",0);
InitRequestVar("eta_list","");
//!isset($_REQUEST["selected_tp"]) ? $_REQUEST["selected_tp"]=0: null;

if (isset($_REQUEST["add"]))
{
	$table_name = "choco_action_nakl";
	if (isset($_REQUEST["keys"]))
	{
		foreach ($_REQUEST["keys"] as $key => $val)
		{
			$keys = array('h_tp_kod_data_nakl'=>$key);
			isset($_REQUEST["data"][$key]) ? $vals = $_REQUEST["data"][$key] : $vals = null;
			Table_Update ($table_name, $keys, $vals);
		}
	}
}

$table_name = "choco_action_nakl";

if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $key => $val)
	{
		$keys = array('h_tp_kod_data_nakl'=>$key);
		Table_Update ($table_name, $keys, null);
	}
}

$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn);

$sql = rtrim(file_get_contents('sql/choco_process_eta_list.sql'));
$sql=stritr($sql,$params);
$eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('eta_list', $eta_list);

if ($_REQUEST["selected_tp"]!=0)
{
$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp'=>$_REQUEST["selected_tp"],':eta_list' => "'".$_REQUEST["eta_list"]."'");
$sql = rtrim(file_get_contents('sql/choco_process_nakl.sql'));
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
if (isset($nakl_list))
{


//print_r($nakl_list);

$smarty->assign('nakl_list', $nakl_list);
}






if (isset($_REQUEST["del_file"]))
{
foreach ($_REQUEST["del_file"] as $k=>$v)
{
$fn=$db->getOne("select fn from choco_files where id=".$k);
unlink("choco_files/".$tn."/".$fn);
$fn=$db->query("delete from choco_files where id=".$k);
}
}


if (isset($_FILES["new_fn"]))
{
if ($_FILES["new_fn"]["name"]!="")
{
	//ses_req();
	$_REQUEST["new"]["tn"]=$tn;
	$d1="choco_files/".$tn;
	if (!file_exists($d1)) {mkdir($d1);}
	//$d1=$d1."/1";
	if (!file_exists($d1)) {mkdir($d1);}
	if (is_uploaded_file($_FILES["new_fn"]['tmp_name'])){move_uploaded_file($_FILES["new_fn"]["tmp_name"], $d1."/".translit($_FILES["new_fn"]["name"]));}
	$_REQUEST["new"]["fn"]=translit($_FILES["new_fn"]["name"]);
	if ($_FILES["new_fn"]['error']==0){
		Table_Update("choco_files",$_REQUEST["new"],$_REQUEST["new"]);
	}
}
}


InitRequestVar("pt",1);
//!isset($_REQUEST["pt"]) ? $_REQUEST["pt"]=1: null;



$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp_kat'=>1,':exp_list_without_ts' => 0,':exp_list_only_ts' => 0);
$sql=rtrim(file_get_contents('sql/choco_files.sql'));
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//echo $sql;
$smarty->assign('file_list', $d);






$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp_kat'=>1,':pt'=>$_REQUEST["pt"],':eta_list' => "'".$_REQUEST["eta_list"]."'");
$sql=rtrim(file_get_contents('sql/choco_process_tp.sql'));
$sql=stritr($sql,$params);
//echo $sql;
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp', $tp);

$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp'=>0,':pt'=>$_REQUEST["pt"],':eta_list' => "'".$_REQUEST["eta_list"]."'");
$sql = rtrim(file_get_contents('sql/choco_process_nakl.sql'));
$sql=stritr($sql,$params);

//echo $sql;

$nakl_list_all = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nakl_list_all', $nakl_list_all);



$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp'=>0,':pt'=>$_REQUEST["pt"],':eta_list' => "'".$_REQUEST["eta_list"]."'");
$sql=rtrim(file_get_contents('sql/choco_process_nakl_total.sql'));
$sql=stritr($sql,$params);
$sql=stritr($sql,$params);
$nakl_list_all_total = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nakl_list_all_total', $nakl_list_all_total);

$smarty->display('choco_process.html');
?>