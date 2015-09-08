<?
//ses_req();

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("ocenka_events", array("year"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		$db->extended->autoExecute("ocenka_events", null, MDB2_AUTOQUERY_DELETE, "year=".$k);
	}
}

if (isset($_REQUEST["new"]))
{
	$affectedRows = $db->extended->autoExecute("ocenka_events", array(
				"name"=>$_REQUEST["new_name"],
				"year"=>$_REQUEST["new_year"]
			), MDB2_AUTOQUERY_INSERT);
}


if (isset($_REQUEST["copy_event"]))
{
	$sql="BEGIN OCENKA_COPY_CRITERIA (".$_REQUEST['y_from'].", ".$_REQUEST['y_to']."); END;";
	//echo $sql;
	$db->query($sql);
}
else
{
	$sql=rtrim(file_get_contents('sql/ocenka_events_admin.sql'));
	$p = array(':dpt_id' => $_SESSION["dpt_id"]);
	$sql=stritr($sql,$p);
	$ocenka_events = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('ocenka_events', $ocenka_events);
	$smarty->display('ocenka_events_admin.html');
}

?>