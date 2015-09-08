<?


if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("bud_fil_contacts_dolgn", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		$db->extended->autoExecute("bud_fil_contacts_dolgn", null, MDB2_AUTOQUERY_DELETE, "id=".$k);
	}
}

if (isset($_REQUEST["add_required"]))
{
	foreach ($_REQUEST["add_required"] as $k=>$v)
	{
		$db->query("begin bud_fil_contacts_fill(".$k."); end;");
	}
}

if (isset($_REQUEST["new"]))
{
	$affectedRows = $db->extended->autoExecute("bud_fil_contacts_dolgn", array("name"=>$_REQUEST["new_name"],"dpt_id" => $_SESSION["dpt_id"]), MDB2_AUTOQUERY_INSERT);
}

$sql=rtrim(file_get_contents('sql/bud_fil_contacts_dolgn.sql'));
$p = array(":dpt_id" => $_SESSION["dpt_id"],':tn'=>$tn);
$sql=stritr($sql,$p);
//echo $sql;
$bud_fil_contacts_dolgn = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d', $bud_fil_contacts_dolgn);
$smarty->display('bud_fil_contacts_dolgn.html');

?>