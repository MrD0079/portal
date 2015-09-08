<?

InitRequestVar("prj_id",0);

//ses_req();

$table="project_grant";


if (isset($_REQUEST["grant"])&&isset($_REQUEST["save"]))
{
	foreach ($_REQUEST["grant"] as $k=>$v)
	{
		foreach ($v as $k1=>$v1)
		{
			foreach ($v1 as $k2=>$v2)
			{
				foreach ($v2 as $k3=>$v3)
				{
					if ($v3!='')
					{
						//$vals=array($k2=>1);
						$keys=array("prj_node_id"=>$k,$k1=>$v3,$k2=>1);
						//print_r($keys);
						//print_r($vals);
						Table_Update($table,$keys,$keys);
					}
				}
			}
		}
	}
}

if (isset($_REQUEST["del_grant"])&&isset($_REQUEST["save"]))
{
	foreach ($_REQUEST["del_grant"] as $k=>$v)
	{
		Table_Update($table,array("id"=>$k),null);
	}
}

$params=array(":dpt_id"=>$_SESSION["dpt_id"]);
$sql=rtrim(file_get_contents('sql/project_grant_heads.sql'));
$sql=stritr($sql,$params);
$project_grant_heads = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('project_grant_heads', $project_grant_heads);


$prg=null;

foreach($project_grant_heads as $k=>$v)
{
	if ($_REQUEST["prj_id"]==$v["id"])
	{
		$prg=$v;
	}
}

if (($_REQUEST["prj_id"]!=0)&&$prg)
{
	$params=array(':prj_id' => $prg["id"]);

	if (isset($_REQUEST["blablabla"]))
	{
		$sql=rtrim(file_get_contents('sql/project_grant_rassilka.sql'));
		$sql=stritr($sql,$params);
		$res = $db->query($sql);
	}

	$sql=rtrim(file_get_contents('sql/project_grant.sql'));
	$sql=stritr($sql,$params);
	$project_grant = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($project_grant as $k=>$v)
	{
		$d[$v["id"]]["head"]["id"]=$v["id"];
		$d[$v["id"]]["head"]["name"]=$v["name"];
		if ($v["tn"])
		{
			if ($v["otv"])
			{
				$d[$v["id"]]["data"]["tn"]["otv"][$v["tn"]]=$v;
			}
			if ($v["chk"])
			{
				$d[$v["id"]]["data"]["tn"]["chk"][$v["tn"]]=$v;
			}
		}
		if ($v["pos"])
		{
			if ($v["otv"])
			{
				$d[$v["id"]]["data"]["pos"]["otv"][$v["pos"]]=$v;
			}
			if ($v["chk"])
			{
				$d[$v["id"]]["data"]["pos"]["chk"][$v["pos"]]=$v;
			}
		}
	}
	isset($d) ? $smarty->assign('project_grant', $d) : null;
}

$sql = rtrim(file_get_contents('sql/emp_exp_spd_list.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('spd_list', $data);

$sql = rtrim(file_get_contents('sql/pos_list_actual_full.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pos_list_actual', $res);


$smarty->display('project_grant.html');

?>