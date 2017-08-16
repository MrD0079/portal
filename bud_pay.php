<?


//ses_req();


audit("открыл bud_pay","bud");

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("bud_pay", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
                Table_Update("bud_pay", array('id'=>$k),null);
	}
}

if (isset($_REQUEST["new"]))
{
	Table_Update("bud_pay", array("name"=>$_REQUEST["new_name"],"dpt_id" => $_SESSION["dpt_id"]), array("name"=>$_REQUEST["new_name"],"dpt_id" => $_SESSION["dpt_id"]));
}

$sql=rtrim(file_get_contents('sql/bud_pay.sql'));
$p = array(":dpt_id" => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$bud_pay = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_pay', $bud_pay);
$smarty->display('bud_pay.html');

?>