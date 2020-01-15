<?

InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
InitRequestVar("fil",0);
InitRequestVar("clusters",0);
InitRequestVar("sd",$_SESSION["month_list"]);
InitRequestVar("ed",$_SESSION["month_list"]);
InitRequestVar("funds",0);
InitRequestVar("db",0);
InitRequestVar("st",0);

$params=array(
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':sd' => "'".$_REQUEST["sd"]."'",
	':ed' => "'".$_REQUEST["ed"]."'",
	':eta_list' => "'".$_REQUEST["eta_list"]."'",
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
	':fil' => $_REQUEST["fil"],
	':clusters' => $_REQUEST["clusters"],
	':funds'=>$_REQUEST["funds"],
	':db' => $_REQUEST["db"],
	':st' => $_REQUEST["st"],
);
$sql = rtrim(file_get_contents('sql/bud_svod_funds_list_fil.sql'));
$sql=stritr($sql,$params);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//echo $sql;

$sql = rtrim(file_get_contents('sql/bud_svod_funds_list.sql'));
$sql=stritr($sql,$params);
$xx = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//echo $sql;
//echo "<pre style='display: none;text-align: left;'>";
//echo var_dump($sql);
//echo "</pre>";
/*foreach ($x as $k=>$v)
{
	foreach ($x1 as $k1=>$v1)
	{
		if ($v1['fil_id']==$v['fil_id'])
		//$x[$k]['period'][$v1['period']]=$v1;
	}
}*/

/*
foreach ($x1 as $k1=>$v1)
{
	$xx[$v1['period']][$v1['fil_id']]=$v1;
}
print_r($xx);
*/
$smarty->assign('xx', $xx);

$sql = rtrim(file_get_contents('sql/bud_svod_funds_act.sql'));
$sql=stritr($sql,$params);

echo "<pre style='display: none;text-align: left;'>";
echo var_dump($sql);
echo "</pre>";

$act = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

$sql = rtrim(file_get_contents('sql/bud_svod_funds_act_total.sql'));
$sql=stritr($sql,$params);
$act_total = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($x as $k=>$v)
{
	foreach ($act as $k1=>$v1)
	{
		if ($v1['fil_id']==$v['fil_id'])
		$x[$k]['act'][$k1]=$v1;
	}
	foreach ($act_total as $k1=>$v1)
	{
		if ($v1['fil_id']==$v['fil_id'])
		$x[$k]['act_total']=$v1;
	}
}
//echo $sql;

$sql = rtrim(file_get_contents('sql/bud_svod_funds_act_local.sql'));
$sql=stritr($sql,$params);
$act_local = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//echo $sql;

$sql = rtrim(file_get_contents('sql/bud_svod_funds_act_local_total.sql'));
$sql=stritr($sql,$params);
$act_local_total = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($x as $k=>$v)
{
	foreach ($act_local as $k1=>$v1)
	{
		if ($v1['fil_id']==$v['fil_id'])
		$x[$k]['act_local'][$k1]=$v1;
	}
	foreach ($act_local_total as $k1=>$v1)
	{
		if ($v1['fil_id']==$v['fil_id'])
		$x[$k]['act_local_total']=$v1;
	}
}

$sql = rtrim(file_get_contents('sql/bud_svod_funds_zay.sql'));
$sql=stritr($sql,$params);
$zay = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

$sql = rtrim(file_get_contents('sql/bud_svod_funds_zay_st.sql'));
$sql=stritr($sql,$params);
$zay_st = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

$sql = rtrim(file_get_contents('sql/bud_svod_funds_zay_total.sql'));
$sql=stritr($sql,$params);
$zay_total = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($x as $k=>$v)
{
	foreach ($zay as $k1=>$v1)
	{
		if ($v1['fil_id']==$v['fil_id'])
		$x[$k]['zay'][$v1['st']]['data'][$k1]=$v1;
	}
	foreach ($zay_st as $k1=>$v1)
	{
		if ($v1['fil_id']==$v['fil_id'])
		$x[$k]['zay'][$v1['st']]['st_total']=$v1;
	}
	foreach ($zay_total as $k1=>$v1)
	{
		if ($v1['fil_id']==$v['fil_id'])
		$x[$k]['zay_total']=$v1;
	}
}

$smarty->assign('list', $x);


$sql = rtrim(file_get_contents('sql/bud_svod_funds_list_total.sql'));
$sql=stritr($sql,$params);
$x = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

$smarty->assign('list_total', $x);


$smarty->display('bud_svod_funds_list.html');

//print_r($x);




?>