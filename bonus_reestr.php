<?
InitRequestVar("smz",$_SESSION["month_list"]);
InitRequestVar("emz",$_SESSION["month_list"]);
InitRequestVar("scr",$now);
InitRequestVar("ecr",$now);
InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
InitRequestVar("region_name","0");
InitRequestVar("date_between","mz");
//InitRequestVar("replacement",0);

//audit ("открыл форму реестра отпусков","vacation");
InitRequestVar("bst",array(0));
$bst = join($_REQUEST["bst"],',');


$params=array(
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':smz' => "'".$_REQUEST["smz"]."'",
	':emz' => "'".$_REQUEST["emz"]."'",
	':scr' => "'".$_REQUEST["scr"]."'",
	':ecr' => "'".$_REQUEST["ecr"]."'",
	':eta_list' => "'".$_REQUEST["eta_list"]."'",
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
	":region_name"=>"'".$_REQUEST["region_name"]."'",
	":bst" => $bst,
	':date_between' => "'".$_REQUEST["date_between"]."'",
);

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$sql=stritr($sql,$params);
$dt = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dt', $dt);

$sql = rtrim(file_get_contents('sql/exp_list_from_parent_only_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_only_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_only_ts', $exp_list_only_ts);

$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_without_ts', $exp_list_without_ts);

$sql = rtrim(file_get_contents('sql/bonus_create_list_h_eta.sql'));
$sql=stritr($sql,$params);
$eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('eta_list', $eta_list);

$sql = rtrim(file_get_contents('sql/bonus_region_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('region_list', $data);

$sql=rtrim(file_get_contents('sql/bonus_types_all.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bonus_types', $data);

$sql=rtrim(file_get_contents('sql/bonus_reestr.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bonus', $data);

$sql=rtrim(file_get_contents('sql/bonus_reestr_total.sql'));
$sql=stritr($sql,$params);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('total', $data);

$smarty->display('bonus_reestr.html');

?>