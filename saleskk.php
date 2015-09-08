<?

//ses_req();
audit("открыл saleskk","saleskk");

InitRequestVar("sd",$_SESSION['month_list']);
InitRequestVar("ed",$_SESSION['month_list']);
InitRequestVar("nets",0);
InitRequestVar("tn_rmkk",0);
InitRequestVar("tn_mkk",0);

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$sql=rtrim(file_get_contents('sql/list_rmkk.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$list_rmkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_rmkk', $list_rmkk);

$sql=rtrim(file_get_contents('sql/list_mkk.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$list_mkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_mkk', $list_mkk);

$sql=rtrim(file_get_contents('sql/nets.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);

if (isset($_REQUEST["generate"]))
{
	$sql=rtrim(file_get_contents('sql/saleskk.sql'));
	$params=array(
		':sd'=>"'".$_REQUEST["sd"]."'",
		':ed'=>"'".$_REQUEST["ed"]."'",
		':net'=>$_REQUEST["nets"],
		':tn_rmkk'=>$_REQUEST["tn_rmkk"],
		':tn_mkk'=>$_REQUEST["tn_mkk"],
		':tn'=>$tn,
	);
	$sql=stritr($sql,$params);
	$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('d', $d);
}

$smarty->display('saleskk.html');

?>