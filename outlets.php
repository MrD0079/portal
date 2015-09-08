<?
audit("открыл outlets","outlets");

InitRequestVar("nets",0);
InitRequestVar("tn_rmkk",0);
InitRequestVar("tn_mkk",0);
InitRequestVar("format",0);
InitRequestVar("sd",$_REQUEST["month_list"]);
InitRequestVar("tz_eta_list",'');
InitRequestVar("flt_id",0);

$params=array(
	':sd'=>"'".$_REQUEST["sd"]."'",
	":tz_eta_list" => "'".$_REQUEST["tz_eta_list"]."'",
	':net'=>$_REQUEST["nets"],
	':format'=>$_REQUEST["format"],
	':tn_rmkk'=>$_REQUEST["tn_rmkk"],
	':tn_mkk'=>$_REQUEST["tn_mkk"],
	':tn'=>$tn,
	':flt_id'=>$_REQUEST["flt_id"]
);

if (isset($_REQUEST["generate"]))
{
$sql=rtrim(file_get_contents('sql/outlets.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign("tz", $data);
}

$sql = rtrim(file_get_contents('sql/outlets_eta_list.sql'));
$sql=stritr($sql,$params);
$tz_eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tz_eta_list', $tz_eta_list);

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$sql=rtrim(file_get_contents('sql/nets.sql'));
$params=array(':tn'=>$tn,':dpt_id'=>$_SESSION['dpt_id']);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);

$sql=rtrim(file_get_contents('sql/list_rmkk.sql'));
$params=array(':tn'=>$tn);
$sql=stritr($sql,$params);
$list_rmkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_rmkk', $list_rmkk);

$sql=rtrim(file_get_contents('sql/list_mkk.sql'));
$params=array(':tn'=>$tn);
$sql=stritr($sql,$params);
$list_mkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_mkk', $list_mkk);

$sql=rtrim(file_get_contents('sql/kk_flt_nets.sql'));
$params=array(':tn' => $tn);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('kk_flt_nets', $data);


$smarty->display('kk_start.html');
$smarty->display('outlets.html');
$smarty->display('kk_end.html');

?>