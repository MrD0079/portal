<?


if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		if ($v["val_date"]!="")
		{
			$v["val_date"]=OraDate2MDBDate($v["val_date"]);
		}
		Table_Update("parameters", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
                Table_Update("parameters", array('id'=>$k),null);
	}
}

if (isset($_REQUEST["new"]))
{
	Table_Update("parameters", array(
				"param_name"=>$_REQUEST["new_param_name"],
				"dpt_id"=>$_SESSION["dpt_id"]
			), array(
				"param_name"=>$_REQUEST["new_param_name"],
				"dpt_id"=>$_SESSION["dpt_id"]
			));
}

$sql=rtrim(file_get_contents('sql/parameters.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$parameters = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('parameters', $parameters);
$smarty->display('parameters.html');

?>