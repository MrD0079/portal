<?php
InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
InitRequestVar("selected_tp",0);
InitRequestVar("ok_traid",1);
InitRequestVar("ok_bonus",1);
InitRequestVar("ok_plan",1);
InitRequestVar("is_act",1);
$params=array(
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':month' => $_REQUEST['month'],
	':eta_list' => "'".$_REQUEST["eta_list"]."'",
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
	':ok_traid' => $_REQUEST["ok_traid"],
	':ok_bonus' => $_REQUEST["ok_bonus"],
	':ok_plan' => $_REQUEST["ok_plan"],
	':tp' => "'".$_REQUEST["selected_tp"]."'",
	':is_act' => $_REQUEST["is_act"],
	':act' => "'".$_REQUEST['act']."'",
);
$sql = rtrim(file_get_contents('sql/exp_list_from_parent_only_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_only_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_only_ts', $exp_list_only_ts);
$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_without_ts', $exp_list_without_ts);
if (file_exists('sql/'.$_REQUEST['act'].'_report_a_eta_list.sql')){
    $sql = rtrim(file_get_contents('sql/'.$_REQUEST['act'].'_report_a_eta_list.sql'));
    $sql=stritr($sql,$params);
    $eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('eta_list', $eta_list);
}
if (isset($_REQUEST["del_file"]))
{
	foreach ($_REQUEST["del_file"] as $k=>$v)
	{
		$fn=$db->getOne("select fn from act_files where id=".$k);
		unlink("files/".$fn);
		$fn=$db->query("delete from act_files where id=".$k);
	}
}
if (isset($_FILES["new_fn"]))
{
	if ($_FILES["new_fn"]["name"]!="")
	{
		$_REQUEST["new"]["tn"]=$tn;
		$d1="files/";
		if (!file_exists($d1)) {mkdir($d1,0777,true);}
		if (is_uploaded_file($_FILES["new_fn"]['tmp_name']))
		{
			$fn=get_new_file_id().'_'.translit($_FILES["new_fn"]["name"]);
			move_uploaded_file($_FILES["new_fn"]["tmp_name"], $d1.$fn);
			$_REQUEST["new"]["fn"]=$fn;
			$_REQUEST["new"]["m"]=$_REQUEST['month'];
			$_REQUEST["new"]["act"]=$_REQUEST['act'];
			Table_Update("act_files",$_REQUEST["new"],$_REQUEST["new"]);
		}
	}
}
?>