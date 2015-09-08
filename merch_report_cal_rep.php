<?


if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("merch_report_cal_rep", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		$db->extended->autoExecute("merch_report_cal_rep", null, MDB2_AUTOQUERY_DELETE, "id=".$k);
	}
}

if (isset($_REQUEST["new"]))
{
	$affectedRows = $db->extended->autoExecute("merch_report_cal_rep", array("name"=>$_REQUEST["new_name"]), MDB2_AUTOQUERY_INSERT);
}

$sql=rtrim(file_get_contents('sql/merch_report_cal_rep.sql'));
$merch_report_cal_rep = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d', $merch_report_cal_rep);
$smarty->display('merch_report_cal_rep.html');

?>