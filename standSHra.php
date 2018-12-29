<?php
if (isset($_REQUEST["save"]))
{
        $_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array('visitdate'=>OraDate2MDBDate($_REQUEST['visitdate']),'tp_kod'=>$_REQUEST['tp_kod']);
	if ($_REQUEST['field1']=='undefined')
        {
            $vals = array($_REQUEST['field']=>$_REQUEST['val']);
        }
        else
        {
            $vals = array($_REQUEST['field']=>$_REQUEST['val'],$_REQUEST['field1']=>$_REQUEST['val1']);
        }
	Table_Update('standSHtp', $keys,$vals);
}
else if (isset($_REQUEST["saveurl"]))
{
        $_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array('h_url'=>$_REQUEST['hurl']);
	if ($_REQUEST['val']==1)
        {
            $vals = $keys;
        }
        else
        {
            $vals = null;
        }
	Table_Update('standSHurl', $keys,$vals);
}
else
{
	InitRequestVar("exp_list_without_ts",0);
	InitRequestVar("exp_list_only_ts",0);
	InitRequestVar("eta_list",$_SESSION["h_eta"]);
	InitRequestVar("sd",$now);
	InitRequestVar("ed",$now);
	InitRequestVar("ok_ts",1);
	InitRequestVar("ok_tm",1);
	InitRequestVar("st_ts",1);
	InitRequestVar("st_tm",1);
	InitRequestVar("dt",$now);
	$params=array(
		':dpt_id' => $_SESSION["dpt_id"],
		':tn'=>$tn,
		':ok_ts' => $_REQUEST["ok_ts"],
		':ok_tm' => $_REQUEST["ok_tm"],
		':st_ts' => $_REQUEST["st_ts"],
		':st_tm' => $_REQUEST["st_tm"],
		':eta_list' => "'".$_REQUEST["eta_list"]."'",
		':sd' => "'".$_REQUEST["sd"]."'",
		':ed' => "'".$_REQUEST["ed"]."'",
		':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
		':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
	);
	$sql = rtrim(file_get_contents('sql/exp_list_from_parent_only_ts.sql'));
	$sql=stritr($sql,$params);
	$exp_list_only_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('exp_list_only_ts', $exp_list_only_ts);
	$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
	$sql=stritr($sql,$params);
	$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('exp_list_without_ts', $exp_list_without_ts);
	$sql = rtrim(file_get_contents('sql/a14to_eta_list.sql'));
	$sql=stritr($sql,$params);
	$eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('eta_list', $eta_list);
	if (isset($_REQUEST['generate']))
	{
		$sql=rtrim(file_get_contents('sql/standSHra.sql'));
		$sql=stritr($sql,$params);
		//echo $sql;
		$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		foreach($d as $k=>$v)
		{
			$sql=rtrim(file_get_contents('sql/standSHra_photos.sql'));
			$params[':tp_kod']=$v['tp_kod_key'];
			$params[':dt']="'".$v['vd']."'";
			$sql=stritr($sql,$params);
			$d[$k]['photos'] = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		}
		$smarty->assign('d', $d);
	}
	$smarty->display('standSHra.html');
}
?>