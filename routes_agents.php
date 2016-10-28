<?

audit("открыл routes_agents","routes");

include_once('SimpleImage.php');

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("routes_agents", array("id"=>$k),$v);
	}
}

if (isset($_FILES["logo"]))
{
$z = $_FILES["logo"];
foreach ($z['tmp_name'] as $k=>$v)
{
	if (is_uploaded_file($z["tmp_name"][$k]))
	{
		$a=pathinfo($z["name"][$k]);
		$fn="ra_logo_".get_new_file_id().".".$a["extension"];
		move_uploaded_file($z["tmp_name"][$k], "files/".$fn);
		$image = new SimpleImage();
		$image->load("files/".$fn);
		$handle=$image->getHeight();
		if ($image->getHeight()>100)
		{
		$image->resizeToHeight(100);
		}
		$image->save("files/".$fn);
		$keys = array("id"=>$k);
		$vals = array("logo"=>$fn);
		Table_Update ("routes_agents", $keys, $vals);
	}
}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		$db->extended->autoExecute("routes_agents", null, MDB2_AUTOQUERY_DELETE, "id=".$k);
	}
}

if (isset($_REQUEST["new"]))
{
	$affectedRows = $db->extended->autoExecute("routes_agents", array("name"=>$_REQUEST["new_agent_name"]), MDB2_AUTOQUERY_INSERT);
}

$sql=rtrim(file_get_contents('sql/routes_agents.sql'));
$routes_agents = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_agents', $routes_agents);
$smarty->display('routes_agents.html');

?>