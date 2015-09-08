<?

InitRequestVar("prj_id",0);

//ses_req();

$table="project";

if (isset($_REQUEST["del_prj"]))
{
	$keys=array("id"=>$_REQUEST["prj_id"]);
	Table_Update($table,$keys,null);
}

if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["new_prj_name"]))
	{
		if ($_REQUEST["new_prj_name"]!="")
		{
			$keys=array("id"=>0);
			$values=array("name"=>$_REQUEST["new_prj_name"],"dpt_id"=>$_SESSION["dpt_id"]);
			Table_Update($table,$keys,$values);
		}
	}
	if (isset($_REQUEST["new"]))
	{
		foreach ($_REQUEST["new"] as $k=>$v)
		{
			$keys=array("id"=>0);
			$values=$v;
			if ($values["name"]!='')
			{
				isset($values["dt_start"])?$values["dt_start"]=OraDate2MDBDate($values["dt_start"]):null;
				isset($values["dt_end"])?$values["dt_end"]=OraDate2MDBDate($values["dt_end"]):null;
				isset($values["dt_fin"])?$values["dt_fin"]=OraDate2MDBDate($values["dt_fin"]):null;
				Table_Update($table,$keys,$values);
			}
		}
	}
	if (isset($_REQUEST["update"]))
	{
		foreach ($_REQUEST["update"] as $k=>$v)
		{
			$keys=array("id"=>$k);
			$values=$v;
			isset($values["dt_start"])?$values["dt_start"]=OraDate2MDBDate($values["dt_start"]):null;
			isset($values["dt_end"])?$values["dt_end"]=OraDate2MDBDate($values["dt_end"]):null;
			isset($values["dt_fin"])?$values["dt_fin"]=OraDate2MDBDate($values["dt_fin"]):null;
			//		print_r($values);
			Table_Update($table,$keys,$values);
		}
	}
	if (isset($_REQUEST["delete"]))
	{
		foreach ($_REQUEST["delete"] as $k=>$v)
		{
			$keys=array("id"=>$k);
			Table_Update($table,$keys,null);
		}
	}
}





$params=array(":dpt_id"=>$_SESSION["dpt_id"]);
$sql=rtrim(file_get_contents('sql/project_new_heads.sql'));
$sql=stritr($sql,$params);
$project_new_heads = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('project_new_heads', $project_new_heads);


$prg=null;

foreach($project_new_heads as $k=>$v)
{
	if ($_REQUEST["prj_id"]==$v["id"])
	{
		$prg=$v;
	}
}

if (($_REQUEST["prj_id"]!=0)&&$prg)
{
	$params=array(':prj_id' => $_REQUEST["prj_id"],":dpt_id"=>$_SESSION["dpt_id"]);
	$sql=rtrim(file_get_contents('sql/project_new.sql'));
	$sql=stritr($sql,$params);
	$project_new = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('project_new', $project_new);
}

$smarty->display('project_new.html');

?>