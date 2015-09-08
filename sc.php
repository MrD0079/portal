<?php

audit("открыл торговые условия работы с ТП","sc");



InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("routes_eta_list",$_SESSION["h_eta"]);
InitRequestVar("sc",0);
InitRequestVar("sc_tp",2);
InitRequestVar("region_name","0");
InitRequestVar("department_name","0");

$params=array(
	':dpt_id' => $_SESSION["dpt_id"],
	":tn"=>$tn,
	":sc_tp" => $_REQUEST["sc_tp"],
	":sc" => $_REQUEST["sc"],
	":exp_list_without_ts" => $_REQUEST["exp_list_without_ts"],
	":exp_list_only_ts" => $_REQUEST["exp_list_only_ts"],
	":routes_eta_list" => "'".$_REQUEST["routes_eta_list"]."'",
	":region_name"=>"'".$_REQUEST["region_name"]."'",
	":department_name"=>"'".$_REQUEST["department_name"]."'",
);



$sql = rtrim(file_get_contents('sql/sc_region_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('region_list', $data);

$sql = rtrim(file_get_contents('sql/sc_department_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('department_list', $data);



if (isset($_REQUEST['del_file']))
{
	$keys = array(
	'id'=>$_REQUEST['del_file']
	);
	$fn=$db->getOne("select fn from sc_files where id=".$_REQUEST['del_file']);
	Table_Update('sc_files',$keys,null);
	unlink('sc_files/'.$fn);
}

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	$_REQUEST["generate"]=1;
	foreach ($_REQUEST["data"] as $k => $v)
	{
		$keys = array('tp_kod'=>$k,'dpt_id'=>$_SESSION["dpt_id"]);
		Table_Update ("sc_tp", $keys, $v);
	}
	foreach ($_FILES["files"]["name"]["fn"] as $k => $v)
	{
		if (is_uploaded_file($_FILES["files"]["tmp_name"]["fn"][$k]))
		{
		$fn=get_new_file_id()."_".translit($v);
		isset($_REQUEST["files"]["dt"][$k]) ? $_REQUEST["files"]["dt"][$k]=OraDate2MDBDate($_REQUEST["files"]["dt"][$k]) : null;
		$dt=$_REQUEST["files"]["dt"][$k];
		$keys = array('tp_kod'=>$k,'dpt_id'=>$_SESSION["dpt_id"],'fn'=>$fn,'dt'=>$dt,'lu'=>null);
		Table_Update ("sc_files", $keys, $keys);
	        $d1="sc_files";
		if (!file_exists($d1)) {mkdir($d1,0777,true);}
		move_uploaded_file($_FILES["files"]["tmp_name"]["fn"][$k], $d1."/".$fn);
		}
	}
}

if (!isset($_REQUEST['del_file']))
{
$sql = rtrim(file_get_contents('sql/exp_list_from_parent_only_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_only_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_only_ts', $exp_list_only_ts);

$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_without_ts', $exp_list_without_ts);


$sql = rtrim(file_get_contents('sql/sc_eta_list.sql'));
$sql=stritr($sql,$params);
$routes_eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_eta_list', $routes_eta_list);
}

if (isset($_REQUEST["generate"]))
{
$sql=rtrim(file_get_contents('sql/sc.sql'));
$sql=stritr($sql,$params);
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//$smarty->assign('list', $list);

//echo $sql;

$sql=rtrim(file_get_contents('sql/sc_files.sql'));
$sql=stritr($sql,$params);
$list_files = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($list as $k=>$v)
{
$d[$v["tp_kod"]]["head"]=$v;
}
foreach ($list_files as $k=>$v)
{
$d[$v["tp_kod"]]["files"][$v["id"]]=$v;
}
isset($d)?$smarty->assign('list',$d):null;
//print_r($d);
}

if (!isset($_REQUEST['del_file']))
{
$smarty->display('sc.html');
}

?>