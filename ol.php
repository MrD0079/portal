<?

audit ("открыл форму редактирования обходного листа","ol");


//ses_req();


if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("ol", array("id"=>$k),$v);
	}
}

if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		$db->extended->autoExecute("ol", null, MDB2_AUTOQUERY_DELETE, "id=".$k);
	}
}

if (isset($_REQUEST["new"]))
{

		Table_Update("ol", $_REQUEST["data_new"],$_REQUEST["data_new"]);

/*
	$affectedRows = $db->extended->autoExecute("ol", array(
				"tn"=>$_REQUEST["data_new"]["tn"],
				"dpt_id"=>$_SESSION["dpt_id"]
			), MDB2_AUTOQUERY_INSERT);
*/
}

$p = array();
$p[':dpt_id'] = $_SESSION["dpt_id"];

$sql = rtrim(file_get_contents('sql/emp_exp_spd_list.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('spd_list', $data);

$sql = rtrim(file_get_contents('sql/ol.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ol', $data);

$sql = rtrim(file_get_contents('sql/ol_gr.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ol_gr', $data);

//print_r($data);

$smarty->display('ol.html');

?>