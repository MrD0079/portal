<?


audit("открыл создание плана адаптации","prob_new");



if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	if ($_REQUEST["tn"]["prob_tn"]!="")
	{
	audit("создал адаптационную программу для ".$_REQUEST["tn"]["prob_tn"],"prob_new");
	$_REQUEST["data"]["data_start"]=OraDate2MDBDate($_REQUEST["data"]["data_start"]);
	$_REQUEST["data"]["data_end"]=OraDate2MDBDate($_REQUEST["data"]["data_end"]);
	$table_name="p_prob_inst";
	$keys=$_REQUEST["tn"];
	$vals=$_REQUEST["data"];
	//print_r($_REQUEST["data"]);
	//print_r($_REQUEST["tn"]);
	Table_Update ($table_name, $keys, $vals);
	}
}



$sql = rtrim(file_get_contents('sql/spd_list.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('spd_list', $data);

$sql = rtrim(file_get_contents('sql/prob_new_prob_list.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('prob_list', $data);

$sql = rtrim(file_get_contents('sql/prob_new_trener_list.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('trener_list', $data);



$smarty->display('prob_new.html');


?>