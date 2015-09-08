<?php
//audit("вошел в список сетей");
///ses_req();



InitRequestVar("selected_tp",0);
//!isset($_REQUEST["selected_tp"]) ? $_REQUEST["selected_tp"]=0: null;


$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn);


if (isset($_REQUEST["del_file"]))
{
foreach ($_REQUEST["del_file"] as $k=>$v)
{
$fn=$db->getOne("select fn from val_mart_files where id=".$k);
unlink("val_mart_files/".$tn."/a/".$fn);
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
	$d1=$d1."/a";
	if (!file_exists($d1)) {mkdir($d1);}
	if (is_uploaded_file($_FILES["new_fn"]['tmp_name'])){move_uploaded_file($_FILES["new_fn"]["tmp_name"], $d1."/".translit($_FILES["new_fn"]["name"]));}
	$_REQUEST["new"]["fn"]=translit($_FILES["new_fn"]["name"]);
	if ($_FILES["new_fn"]['error']==0){Table_Update("val_mart_files",$_REQUEST["new"],$_REQUEST["new"]);}
}
}


InitRequestVar("pt",1);

//!isset($_REQUEST["pt"]) ? $_REQUEST["pt"]=1: null;




$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp_kat'=>1,':exp_list_without_ts' => 0,':exp_list_only_ts' => 0);





$sql=rtrim(file_get_contents('sql/val_mart_files.sql'));
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//echo $sql;
$smarty->assign('file_list', $d);





$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp_kat'=>1,':pt'=>$_REQUEST["pt"]);
$sql=rtrim(file_get_contents('sql/val_mart_process.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//echo $sql;
$smarty->assign('tp', $tp);

$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp_kat'=>1,':pt'=>$_REQUEST["pt"]);
$sql=rtrim(file_get_contents('sql/val_mart_process_total.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//echo $sql;
$smarty->assign('tp_total', $tp);


$smarty->display('val_mart_process_a.html');
?>