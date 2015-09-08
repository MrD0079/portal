<?php

audit("ko","ko");
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



if (isset($_REQUEST["add_nakl"]))
{
	$table_name = "ko_action_nakl";
	audit("add action_nakl","ko");

	if (isset($_REQUEST["add"]))
	{
		$keys = array(
			'tp_kod'=>$a[0],
			'fio_eta'=>$a[1],
			'id'=>0
		);
		$_REQUEST["add"]["summa"]=str_replace(",", ".", $_REQUEST["add"]["summa"]);
		$_REQUEST["add"]["bonus"]=str_replace(",", ".", $_REQUEST["add"]["bonus"]);
		$_REQUEST["add"]["bonus_plan"]=str_replace(",", ".", $_REQUEST["add"]["bonus_plan"]);
		$_REQUEST["add"]["data"]=OraDate2MDBDate($_REQUEST["add"]["data"]);
		$_REQUEST["add"]["tn_ts"] = $tn;
		$values = $_REQUEST["add"];
		Table_Update ($table_name, $keys, $values);
	}
}

if (isset($_REQUEST["del"]))
{
	$table_name = "ko_action_nakl";
	audit("удалил акционную накладную","ko");
	foreach ($_REQUEST["del"] as $key => $val)
	{
		$keys = array('id'=>$key);
		$values = null;
		Table_Update ($table_name, $keys, $values);
	}
}







if (isset($_REQUEST["del_file"]))
{
foreach ($_REQUEST["del_file"] as $k=>$v)
{
$fn=$db->getOne("select fn from ko_files where id=".$k);
$tip=$db->getOne("select tip from ko_files where id=".$k);
unlink("ko_files/".$tn."/".$tip."/".$fn);
$res=$db->query("delete from ko_files where id=".$k);
audit("del file ko_files/".$tn."/".$tip."/".$fn,"ko");
}
}



if (isset($_FILES["new_fn"]))
{
foreach ($_FILES["new_fn"]["name"] as $k=>$v)
{
if ($v!="")
{
	$d1="ko_files/".$tn;
	if (!file_exists($d1)) {mkdir($d1);}
	$d1=$d1."/".$k;
	if (!file_exists($d1)) {mkdir($d1);}
	$_REQUEST["new"]["tn"]=$tn;
	$_REQUEST["new"]["tip"]=$k;
	$_REQUEST["new"]["fn"]=translit($v);
	if ($_FILES["new_fn"]["error"][$k]==0){Table_Update("ko_files",$_REQUEST["new"],$_REQUEST["new"]);}
	if (is_uploaded_file($_FILES["new_fn"]['tmp_name'][$k])){move_uploaded_file($_FILES["new_fn"]["tmp_name"][$k], $d1."/".translit($_FILES["new_fn"]["name"][$k]));}
}
}
}



//echo $sql;



$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"],':exp_list_without_ts' => 0,':exp_list_only_ts' => 0,':tip'=>2);
$sql=rtrim(file_get_contents('sql/ko_files.sql'));
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('file_list_b', $d);


$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"],':exp_list_without_ts' => 0,':exp_list_only_ts' => 0,':tip'=>3);
$sql=rtrim(file_get_contents('sql/ko_files.sql'));
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('file_list_c', $d);


$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=rtrim(file_get_contents('sql/ko_process.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp', $tp);

$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=rtrim(file_get_contents('sql/ko_process_nakl.sql'));
$sql=stritr($sql,$params);
$nakl_list_all = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nakl_list_all', $nakl_list_all);

$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=rtrim(file_get_contents('sql/ko_process_nakl_total.sql'));
$sql=stritr($sql,$params);
$nakl_list_all_total = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nakl_list_all_total', $nakl_list_all_total);

$smarty->display('ko_process.html');
?>