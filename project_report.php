<?

InitRequestVar("prj_id",0);
InitRequestVar("table",1);
InitRequestVar("exp_list_without_ts",0);

//ses_req();

$params=array(
	':prj_id' => $_REQUEST["prj_id"],
	":dpt_id" => $_SESSION["dpt_id"],
	":tn"=>$tn,
	":exp_list_without_ts" => $_REQUEST["exp_list_without_ts"]
);

$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_without_ts', $exp_list_without_ts);

$sql=rtrim(file_get_contents('sql/project_report_heads.sql'));
$sql=stritr($sql,$params);
$project_report_heads = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('project_report_heads', $project_report_heads);

$prg=null;

foreach($project_report_heads as $k=>$v)
{
	if ($_REQUEST["prj_id"]==$v["id"])
	{
		$prg=$v;
	}
}

if (($_REQUEST["prj_id"]!=0)&&$prg&&(isset($_REQUEST["generate"])))
{
	$sql=rtrim(file_get_contents('sql/project_report_1.sql'));
	$sql=stritr($sql,$params);

	$project_report_1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($project_report_1 as $k=>$v)
	{
		$project_report_1[$k]["cnt"]=split('/',$v["cnt"]);
	}
	isset($project_report_1) ? $smarty->assign('project_report_1', $project_report_1):null;

	$sql=rtrim(file_get_contents('sql/project_report_2.sql'));
	$sql=stritr($sql,$params);
	$project_report_2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($project_report_2 as $k=>$v)
	{
		$d[$v["p1_tn"]]["head"]=$v;
		$d[$v["p1_tn"]]["data"][$v["p1_p2_name"]][$v["p1_p3_name"]]=$v;
		$d_grp[$v["p1_p2_name"]][$v["p1_p3_name"]]=$v;
	}
	isset($d) ? $smarty->assign('project_report_2', $d):null;
	isset($d_grp) ? $smarty->assign('project_report_2_grp', $d_grp):null;
	//print_r($d_grp);
}

$smarty->display('project_report.html');

?>