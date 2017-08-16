<?


//ses_req();


audit("открыл tr","bud");

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("tr", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		Table_Update("tr", array('id'=>$k),null);
	}
}

if (isset($_REQUEST["new"]))
{
	Table_Update("tr",array
		(
			"name"=>$_REQUEST["new_name"],
			"for_eta"=>$_REQUEST["new_for_eta"],
			"for_prez"=>$_REQUEST["new_for_prez"],
			"kod"=>$_REQUEST["new_kod"],
			"max_stud"=>$_REQUEST["new_max_stud"],
			"days"=>$_REQUEST["new_days"],
			"test_len"=>$_REQUEST["new_test_len"],
			"text" => $_REQUEST["new_text"]
		),array
		(
			"name"=>$_REQUEST["new_name"],
			"for_eta"=>$_REQUEST["new_for_eta"],
			"for_prez"=>$_REQUEST["new_for_prez"],
			"kod"=>$_REQUEST["new_kod"],
			"max_stud"=>$_REQUEST["new_max_stud"],
			"days"=>$_REQUEST["new_days"],
			"test_len"=>$_REQUEST["new_test_len"],
			"text" => $_REQUEST["new_text"]
		) );
}

$sql=rtrim(file_get_contents('sql/tr_all.sql'));
$p = array(":dpt_id" => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$tr = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tr', $tr);
$smarty->display('tr.html');

?>