<?php

//ses_req();

//InitRequestVar("selected_tp",0);
InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
//InitRequestVar("ok_traid",1);
//InitRequestVar("ok_chief",1);

$params=array(
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':eta_list' => "'".$_REQUEST["eta_list"]."'",
//	':ok_traid' => $_REQUEST["ok_traid"],
//	':ok_chief' => $_REQUEST["ok_chief"],
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
//	':tp' => "'".$_REQUEST["selected_tp"]."'"
);

$sql = rtrim(file_get_contents('sql/exp_list_from_parent_only_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_only_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_only_ts', $exp_list_only_ts);

$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_without_ts', $exp_list_without_ts);

$sql = rtrim(file_get_contents('sql/a1407nto_report_a_eta_list.sql'));
$sql=stritr($sql,$params);
$eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('eta_list', $eta_list);

if (isset($_REQUEST["del_file"]))
{
	foreach ($_REQUEST["del_file"] as $k=>$v)
	{
		$fn=$db->getOne("select fn from a1407nto_files where id=".$k);
		unlink("a1407nto_files/".$tn."/".$fn);
		$fn=$db->query("delete from a1407nto_files where id=".$k);
	}
}

if (isset($_FILES["new_fn"]))
{
	if ($_FILES["new_fn"]["name"]!="")
	{
		$_REQUEST["new"]["tn"]=$tn;
		$d1="a1407nto_files";
		if (!file_exists($d1)) {mkdir($d1);}
		$d1="a1407nto_files/".$tn;
		if (!file_exists($d1)) {mkdir($d1);}
		if (is_uploaded_file($_FILES["new_fn"]['tmp_name'])){move_uploaded_file($_FILES["new_fn"]["tmp_name"], $d1."/".translit($_FILES["new_fn"]["name"]));}
		$_REQUEST["new"]["fn"]=translit($_FILES["new_fn"]["name"]);
		if ($_FILES["new_fn"]['error']==0){
			Table_Update("a1407nto_files",$_REQUEST["new"],$_REQUEST["new"]);
		}
	}
}

if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["data"]))
	{
		foreach($_REQUEST["data"] as $k=>$v)
		{
			$keys = array('tp_kod'=>$k);
			isset($v["bonus_dt1"]) ? $v["bonus_dt1"]=OraDate2MDBDate($v["bonus_dt1"]) : null;
			Table_Update ('a1407nto_tp_select', $keys, $v);
		}
	}
	if (isset($_REQUEST["data_files"]))
	{
		foreach($_REQUEST["data_files"] as $k=>$v)
		{
			$keys = array('id'=>$k);
			Table_Update ('a1407nto_files', $keys, $v);
		}
	}
}

if (isset($_REQUEST["generate"]))
{
$sql=rtrim(file_get_contents("sql/a1407nto_report_a.sql"));
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

$sql=rtrim(file_get_contents('sql/a1407nto_report_a_photo_files.sql'));
$sql=stritr($sql,$params);
$df = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

if (isset($d)&&isset($df))
{
	foreach ($d as $k=>$v)
	{
		foreach ($df as $k1=>$v1)
		{
			if ($v1["tp_kod"]==$v["tp_kod"])
			{
			$d[$k]["files"][$v1["id"]]=$v1["fn"];
			}
		}
	}
}
$smarty->assign("list", $d);
}

$smarty->display('a1407nto_report_a.html');

?>