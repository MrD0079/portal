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
	Table_Update('a14totp', $keys,$vals);
}
else
{
	InitRequestVar("exp_list_without_ts",0);
	InitRequestVar("exp_list_only_ts",0);
	InitRequestVar("eta_list",$_SESSION["h_eta"]);
	InitRequestVar("sd",$now);
	InitRequestVar("ed",$now);
	InitRequestVar("ok_photo",1);
	InitRequestVar("ok_visit",1);
	InitRequestVar("ok_ts",1);
	InitRequestVar("ok_auditor",1);
	InitRequestVar("st_ts",1);
	InitRequestVar("st_auditor",1);
	InitRequestVar("standart",1);
	$params=array(
		':dpt_id' => $_SESSION["dpt_id"],
		':tn'=>$tn,
		':ok_photo' => $_REQUEST["ok_photo"],
		':ok_visit' => $_REQUEST["ok_visit"],
		':ok_ts' => $_REQUEST["ok_ts"],
		':ok_auditor' => $_REQUEST["ok_auditor"],
		':st_ts' => $_REQUEST["st_ts"],
		':st_auditor' => $_REQUEST["st_auditor"],
		':eta_list' => "'".$_REQUEST["eta_list"]."'",
		':sd' => "'".$_REQUEST["sd"]."'",
		':ed' => "'".$_REQUEST["ed"]."'",
		':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
		':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
		':standart' => $_REQUEST["standart"],
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
		$sql=rtrim(file_get_contents('sql/a14to_accept2.sql'));
		$sql=stritr($sql,$params);
		//echo $sql;
		$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		foreach($d as $k=>$v)
		{
			$sql=rtrim(file_get_contents('sql/a14to_accept2_photos.sql'));
			$params[':tp_kod']=$v['tp_kod_key'];
			$params[':dt']="'".$v['vd']."'";
			$sql=stritr($sql,$params);
			$d[$k]['photos'] = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		}
		$smarty->assign('d', $d);
		$sql=rtrim(file_get_contents('sql/a14to_accept2_total.sql'));
		$sql=stritr($sql,$params);
		$t = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('t', $t);
		$sql=rtrim(file_get_contents('sql/a14to_accept2_total1.sql'));
		$sql=stritr($sql,$params);
		$t1 = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('t1', $t1);
	}
	$smarty->display('a14to_accept2.html');
}
?>