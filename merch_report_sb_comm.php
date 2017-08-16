<?


if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("merch_report_sb_comm", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		Table_Update("merch_report_sb_comm", array('id'=>$k),null);
	}
}

if (isset($_REQUEST["new"]))
{
	Table_Update("merch_report_sb_comm", array("name"=>$_REQUEST["new_name"]), array("name"=>$_REQUEST["new_name"]));
}

$sql=rtrim(file_get_contents('sql/merch_report_sb_comm.sql'));
$merch_report_sb_comm = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d', $merch_report_sb_comm);
$smarty->display('merch_report_sb_comm.html');

?>