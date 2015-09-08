<?
//ses_req();

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		if ($v["val_date"]!="")
		{
			$v["val_date"]=OraDate2MDBDate($v["val_date"]);
		}
		//$v["val_number"]=str_replace(",", ".", $v["val_number"]);
		Table_Update("parameters", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		$db->extended->autoExecute("parameters", null, MDB2_AUTOQUERY_DELETE, "id=".$k);
	}
}

if (isset($_REQUEST["new"]))
{
	$affectedRows = $db->extended->autoExecute("parameters", array(
				"param_name"=>$_REQUEST["new_param_name"],
				"dpt_id"=>$_SESSION["dpt_id"]
			), MDB2_AUTOQUERY_INSERT);
}

$sql=rtrim(file_get_contents('sql/parameters.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$parameters = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('parameters', $parameters);
$smarty->display('parameters.html');

?>