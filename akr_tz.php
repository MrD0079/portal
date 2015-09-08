<?

audit("открыл akr_tz","akr");

if (isset($_REQUEST["save"])&&isset($_REQUEST["new"]))
{
	Table_Update("akr_tz", array("id"=>$_REQUEST["edit_id"]),$_REQUEST["new"]);
}

if (isset($_REQUEST["del"]))
{
	Table_Update("akr_tz", array("id"=>$_REQUEST["del"]),null);
}

if (isset($_REQUEST["add"])&&isset($_REQUEST["new"]))
{
	Table_Update("akr_tz", $_REQUEST["new"],$_REQUEST["new"]);
}

//ses_req();

$sql=rtrim(file_get_contents('sql/akr_tz.sql'));
$akr_tz = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);



if (isset ($_REQUEST['id']))
{
	foreach ($akr_tz as $k=>$v)
	{
		if ($v['id']==$_REQUEST['id'])
		{
			$smarty->assign('akr_tz_edit', $v);
		}
	}
}


foreach ($akr_tz as $k=>$v)
{
	$sql=rtrim(file_get_contents('sql/akr_tz_files.sql'));
	$p = array(":tz_id" => $v['id']);
	$sql=stritr($sql,$p);
	$z3 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$akr_tz[$k]['files']=$z3;
}



$smarty->assign('akr_tz', $akr_tz);
//print_r($akr_tz);




$sql=rtrim(file_get_contents('sql/akr_city.sql'));
$akr_city = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('akr_city', $akr_city);

$sql=rtrim(file_get_contents('sql/akr_diviz.sql'));
$akr_diviz = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('akr_diviz', $akr_diviz);

$sql=rtrim(file_get_contents('sql/akr_nets.sql'));
$akr_nets = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('akr_nets', $akr_nets);

$sql=rtrim(file_get_contents('sql/akr_contr_ag.sql'));
$akr_contr_ag = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('akr_contr_ag', $akr_contr_ag);

$sql=rtrim(file_get_contents('sql/akr_contr_avk.sql'));
$akr_contr_avk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('akr_contr_avk', $akr_contr_avk);

$sql=rtrim(file_get_contents('sql/akr_cont_avk.sql'));
$akr_cont_avk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('akr_cont_avk', $akr_cont_avk);




$smarty->display('akr_tz.html');



?>