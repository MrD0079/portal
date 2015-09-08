<?

audit("открыл atd_tz","atd");

if (isset($_REQUEST["save"])&&isset($_REQUEST["new"]))
{
	Table_Update("atd_tz", array("id"=>$_REQUEST["edit_id"]),$_REQUEST["new"]);
}

if (isset($_REQUEST["del"]))
{
	Table_Update("atd_tz", array("id"=>$_REQUEST["del"]),null);
}

if (isset($_REQUEST["add"])&&isset($_REQUEST["new"]))
{
	Table_Update("atd_tz", $_REQUEST["new"],$_REQUEST["new"]);
}

//ses_req();

$sql=rtrim(file_get_contents('sql/atd_tz.sql'));
$atd_tz = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);



if (isset ($_REQUEST['id']))
{
	foreach ($atd_tz as $k=>$v)
	{
		if ($v['id']==$_REQUEST['id'])
		{
			$smarty->assign('atd_tz_edit', $v);
		}
	}
}


foreach ($atd_tz as $k=>$v)
{
	$sql=rtrim(file_get_contents('sql/atd_tz_files.sql'));
	$p = array(":tz_id" => $v['id']);
	$sql=stritr($sql,$p);
	$z3 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$atd_tz[$k]['files']=$z3;
}



$smarty->assign('atd_tz', $atd_tz);
//print_r($atd_tz);




$sql=rtrim(file_get_contents('sql/atd_city.sql'));
$atd_city = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('atd_city', $atd_city);

$sql=rtrim(file_get_contents('sql/atd_diviz.sql'));
$atd_diviz = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('atd_diviz', $atd_diviz);

$sql=rtrim(file_get_contents('sql/atd_nets.sql'));
$atd_nets = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('atd_nets', $atd_nets);

$sql=rtrim(file_get_contents('sql/atd_contr_ag.sql'));
$atd_contr_ag = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('atd_contr_ag', $atd_contr_ag);

$sql=rtrim(file_get_contents('sql/atd_contr_avk.sql'));
$atd_contr_avk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('atd_contr_avk', $atd_contr_avk);

$sql=rtrim(file_get_contents('sql/atd_cont_avk.sql'));
$atd_cont_avk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('atd_cont_avk', $atd_cont_avk);




$smarty->display('atd_tz.html');



?>