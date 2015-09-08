<?php
//audit("вошел в список сетей");
//ses_req();

InitRequestVar("selected_tp",0);
InitRequestVar("eta_list","");
//!isset($_REQUEST["selected_tp"]) ? $_REQUEST["selected_tp"]=0: null;

if (isset($_REQUEST["add"]))
{
	$table_name = "a7p1_action_nakl";
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
				if (isset($_REQUEST["bonus"][$key])&&isset($_REQUEST["summnds_pg"][$key]))
				{
				if (!($_REQUEST["bonus"][$key]>$_REQUEST["summnds_pg"][$key]*0.21))
				{
					Table_Update ($table_name, $keys, $values);
				}}
				else
				{
					Table_Update ($table_name, $keys, $values);
				}
			}
		}
	}
	if (isset($_REQUEST["bonus"]))
	{
		foreach ($_REQUEST["bonus"] as $key => $val)
		{
			$keys = array(
				'tp_kod'=>$_REQUEST["selected_tp"],
				'nakl'=>$key
			);
			$values = array('bonus'=>$val);
			if ($_REQUEST["bonus"][$key]>$_REQUEST["summnds_pg"][$key]*0.21)
			{
				echo "<p style=\"color:red\">Ќакладна€ ".$key." не добавлена, так как превышена затратна€ часть по акции.</p>";
			}
			else
			{
				Table_Update ($table_name, $keys, $values);
			}
		}
	}
	if (isset($_REQUEST["text"]))
	{
		foreach ($_REQUEST["text"] as $key => $val)
		{
			$keys = array(
				'tp_kod'=>$_REQUEST["selected_tp"],
				'nakl'=>$key
			);
			$values = array('text'=>$val);
				if (isset($_REQUEST["bonus"][$key])&&isset($_REQUEST["summnds_pg"][$key]))
				{
				if (!($_REQUEST["bonus"][$key]>$_REQUEST["summnds_pg"][$key]*0.21))
				{
					Table_Update ($table_name, $keys, $values);
				}}
				else
				{
					Table_Update ($table_name, $keys, $values);
				}
		}
	}
	/*if (isset($_REQUEST["ya"]))
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
	}*/
}

if (isset($_REQUEST["save"]))
{
	$table_name = "a7p1_action_nakl";
	if (isset($_REQUEST["text_all"]))
	{
		foreach ($_REQUEST["text_all"] as $key => $val)
		{
			foreach($val as $k1=>$v1)
			{
				$keys = array(
					'tp_kod'=>$key,
					'nakl'=>$k1
				);
				$values = array('text'=>$v1);
				Table_Update ($table_name, $keys, $values);
			}
		}
	}
}


$table_name = "a7p1_action_nakl";
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




$sql = rtrim(file_get_contents('sql/a7p1_process_eta_list.sql'));
$sql=stritr($sql,$params);
$eta_list = $db->getCol($sql);
$smarty->assign('eta_list', $eta_list);





if ($_REQUEST["selected_tp"]!=0)
{
$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp'=>$_REQUEST["selected_tp"],':eta_list' => "'".$_REQUEST["eta_list"]."'");
$sql = rtrim(file_get_contents('sql/a7p1_process_nakl.sql'));
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
$fn=$db->getOne("select fn from a7p1_files where id=".$k);
unlink("a7p1_files/".$tn."/".$fn);
$fn=$db->query("delete from a7p1_files where id=".$k);
}
}


if (isset($_FILES["new_fn"]))
{
if ($_FILES["new_fn"]["name"]!="")
{
	//ses_req();
	$_REQUEST["new"]["tn"]=$tn;
	$d1="a7p1_files/".$tn;
	if (!file_exists($d1)) {mkdir($d1);}
	//$d1=$d1."/1";
	if (!file_exists($d1)) {mkdir($d1);}
	if (is_uploaded_file($_FILES["new_fn"]['tmp_name'])){move_uploaded_file($_FILES["new_fn"]["tmp_name"], $d1."/".translit($_FILES["new_fn"]["name"]));}
	$_REQUEST["new"]["fn"]=translit($_FILES["new_fn"]["name"]);
	if ($_FILES["new_fn"]['error']==0){
		$_REQUEST["new"]["bonus"]=str_replace(",",".",$_REQUEST["new"]["bonus"]);
		Table_Update("a7p1_files",$_REQUEST["new"],$_REQUEST["new"]);
	}
}
}


InitRequestVar("pt",1);
//!isset($_REQUEST["pt"]) ? $_REQUEST["pt"]=1: null;



$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp_kat'=>1,':exp_list_without_ts' => 0,':exp_list_only_ts' => 0);
$sql=rtrim(file_get_contents('sql/a7p1_files.sql'));
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//echo $sql;
$smarty->assign('file_list', $d);






$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp_kat'=>1,':pt'=>$_REQUEST["pt"],':eta_list' => "'".$_REQUEST["eta_list"]."'");
$sql=rtrim(file_get_contents('sql/a7p1_process_tp.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp', $tp);

$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp'=>0,':pt'=>$_REQUEST["pt"],':eta_list' => "'".$_REQUEST["eta_list"]."'");
$sql = rtrim(file_get_contents('sql/a7p1_process_nakl.sql'));
$sql=stritr($sql,$params);

//echo $sql;

$nakl_list_all = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nakl_list_all', $nakl_list_all);



$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp'=>0,':pt'=>$_REQUEST["pt"],':eta_list' => "'".$_REQUEST["eta_list"]."'");
$sql=rtrim(file_get_contents('sql/a7p1_process_nakl_total.sql'));
$sql=stritr($sql,$params);
$sql=stritr($sql,$params);
$nakl_list_all_total = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nakl_list_all_total', $nakl_list_all_total);

$smarty->display('a7p1_process.html');
?>