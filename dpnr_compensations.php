<?
if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("dpnr_compensations", array("id"=>$k),$v);
	}
}
if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
                Table_Update("dpnr_compensations", array('id'=>$k),null);
	}
}
if (isset($_REQUEST["new"]))
{
	Table_Update("dpnr_compensations", array("name"=>$_REQUEST["new_name"]), array("name"=>$_REQUEST["new_name"]));
}
$sql=rtrim(file_get_contents('sql/dpnr_compensations.sql'));
$compensations = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d', $compensations);
$smarty->display('dpnr_compensations.html');
?>