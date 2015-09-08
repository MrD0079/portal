<?php


if (isset($_REQUEST["save"]))
{
	$keys = array('tp_kod'=>$_REQUEST['id']);
	$vals = array($_REQUEST['field']=>$_REQUEST['val']);
	Table_Update("a14ss_pb", $keys,$vals);
}
else
{

InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
$params=array(
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
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

if (isset($_REQUEST["generate"]))
{
$sql=rtrim(file_get_contents('sql/a14ss_pb.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp', $tp);
}
$smarty->display('a14ss_pb.html');

}

?>