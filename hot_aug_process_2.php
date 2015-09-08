<?php
//audit("вошел в список сетей");
//ses_req();



InitRequestVar("selected_tp",0);
InitRequestVar("eta_list","");
//!isset($_REQUEST["selected_tp"]) ? $_REQUEST["selected_tp"]=0: null;


$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn);



if (isset($_REQUEST["save"]))
{
	$table_name = "hot_aug_tp_select";
	if (isset($_REQUEST["selected2_changed"]))
	{
		foreach ($_REQUEST["selected2_changed"] as $key => $val)
		{
			if ($val!=null)
			{
				$keys = array('tp_kod'=>$key);
				$values = array('selected2'=>Bool2Int($val));
				Table_Update ($table_name, $keys, $values);
			}
		}
	}
	if (isset($_REQUEST["fakt_bonus"]))
	{
		foreach ($_REQUEST["fakt_bonus"] as $key => $val)
		{
			if ($val!=null)
			{
				$keys = array('tp_kod'=>$key);
				$values = array('fakt_bonus'=>str_replace(",", ".", $val));
				Table_Update ($table_name, $keys, $values);
			}
		}
	}
}





if (isset($_REQUEST["del_file"]))
{
foreach ($_REQUEST["del_file"] as $k=>$v)
{
$fn=$db->getOne("select fn from hot_aug_files where id=".$k);
unlink("hot_aug_files/".$tn."/2/".$fn);
$fn=$db->query("delete from hot_aug_files where id=".$k);
}
}


if (isset($_FILES["new_fn"]))
{
if ($_FILES["new_fn"]["name"]!="")
{
	//ses_req();
	$_REQUEST["new"]["tn"]=$tn;
	$d1="hot_aug_files/".$tn;
	if (!file_exists($d1)) {mkdir($d1);}
	$d1=$d1."/2";
	if (!file_exists($d1)) {mkdir($d1);}
	if (is_uploaded_file($_FILES["new_fn"]['tmp_name'])){move_uploaded_file($_FILES["new_fn"]["tmp_name"], $d1."/".translit($_FILES["new_fn"]["name"]));}
	$_REQUEST["new"]["fn"]=translit($_FILES["new_fn"]["name"]);
	if ($_FILES["new_fn"]['error']==0){
		$_REQUEST["new"]["bonus"]=str_replace(",",".",$_REQUEST["new"]["bonus"]);
		Table_Update("hot_aug_files",$_REQUEST["new"],$_REQUEST["new"]);
	}
}
}


InitRequestVar("pt",1);

//!isset($_REQUEST["pt"]) ? $_REQUEST["pt"]=1: null;




$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp_kat'=>2,':exp_list_without_ts' => 0,':exp_list_only_ts' => 0);


$sql = rtrim(file_get_contents('sql/hot_aug_process_eta_list.sql'));
$sql=stritr($sql,$params);
$eta_list = $db->getCol($sql);
$smarty->assign('eta_list', $eta_list);





$sql=rtrim(file_get_contents('sql/hot_aug_files.sql'));
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//echo $sql;
$smarty->assign('file_list', $d);





$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp_kat'=>1,':pt'=>$_REQUEST["pt"],':eta_list' => "'".$_REQUEST["eta_list"]."'");
$sql=rtrim(file_get_contents('sql/hot_aug_process_2.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//echo $sql;
$smarty->assign('tp', $tp);

$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp_kat'=>1,':pt'=>$_REQUEST["pt"],':eta_list' => "'".$_REQUEST["eta_list"]."'");
$sql=rtrim(file_get_contents('sql/hot_aug_process_2_total.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//echo $sql;
$smarty->assign('tp_total', $tp);


$smarty->display('hot_aug_process_2.html');
?>