<?

audit("открыл azl_tz","azl");

if (isset($_REQUEST["save"])&&isset($_REQUEST["new"]))
{
	Table_Update("azl_tz", array("id"=>$_REQUEST["edit_id"]),$_REQUEST["new"]);
}

if (isset($_REQUEST["del"]))
{
	Table_Update("azl_tz", array("id"=>$_REQUEST["del"]),null);
}

if (isset($_REQUEST["add"])&&isset($_REQUEST["new"]))
{
	Table_Update("azl_tz", $_REQUEST["new"],$_REQUEST["new"]);
}

//ses_req();

$sql=rtrim(file_get_contents('sql/azl_tz.sql'));
$azl_tz = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);



if (isset ($_REQUEST['id']))
{
	foreach ($azl_tz as $k=>$v)
	{
		if ($v['id']==$_REQUEST['id'])
		{
			$smarty->assign('azl_tz_edit', $v);
		}
	}
}


foreach ($azl_tz as $k=>$v)
{
	$sql=rtrim(file_get_contents('sql/azl_tz_files.sql'));
	$p = array(":tz_id" => $v['id']);
	$sql=stritr($sql,$p);
	$z3 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$azl_tz[$k]['files']=$z3;
}



$smarty->assign('azl_tz', $azl_tz);
//print_r($azl_tz);




$sql=rtrim(file_get_contents('sql/azl_city.sql'));
$azl_city = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('azl_city', $azl_city);

$sql=rtrim(file_get_contents('sql/azl_diviz.sql'));
$azl_diviz = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('azl_diviz', $azl_diviz);

$sql=rtrim(file_get_contents('sql/azl_nets.sql'));
$azl_nets = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('azl_nets', $azl_nets);

$sql=rtrim(file_get_contents('sql/azl_contr_ag.sql'));
$azl_contr_ag = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('azl_contr_ag', $azl_contr_ag);

$sql=rtrim(file_get_contents('sql/azl_contr_avk.sql'));
$azl_contr_avk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('azl_contr_avk', $azl_contr_avk);

$sql=rtrim(file_get_contents('sql/azl_cont_avk.sql'));
$azl_cont_avk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('azl_cont_avk', $azl_cont_avk);




$smarty->display('azl_tz.html');



?>