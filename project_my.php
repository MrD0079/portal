<?

InitRequestVar("prj_id",0);



$table="project_report";

if ((isset($_REQUEST["z"]))&&(isset($_REQUEST["save"])))
{
	foreach ($_REQUEST["z"] as $k=>$v)
	{
		$keys=array("prj_node_id"=>$k,"tn"=>$tn);
		$values=$v;
		//print_r($keys);
		//print_r($values);
		Table_Update($table,$keys,$values);
	}
}


$params=array(":dpt_id"=>$_SESSION["dpt_id"],":tn"=>$tn);
$sql=rtrim(file_get_contents('sql/project_my_heads.sql'));
$sql=stritr($sql,$params);
$project_my_heads = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('project_my_heads', $project_my_heads);


$prg=null;

foreach($project_my_heads as $k=>$v)
{
	if ($_REQUEST["prj_id"]==$v["id"])
	{
		$prg=$v;
	}
}

if (($_REQUEST["prj_id"]!=0)&&$prg)
{
	$params=array(':prj_id' => $_REQUEST["prj_id"],":dpt_id"=>$_SESSION["dpt_id"],":tn"=>$tn);
	$sql=rtrim(file_get_contents('sql/project_my.sql'));
	$sql=stritr($sql,$params);
	$project_my = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('project_my', $project_my);
	//print_r($project_my);

	$params=array(':prj_id' => $_REQUEST["prj_id"],":dpt_id"=>$_SESSION["dpt_id"],":tn"=>$tn);
	$sql=rtrim(file_get_contents('sql/project_my_total.sql'));
	$sql=stritr($sql,$params);
	$project_my_total = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('project_my_total', $project_my_total);
	//print_r($project_my_total);
}

$smarty->display('project_my.html');

?>