<?

InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
InitRequestVar("fil",0);
InitRequestVar("clusters",0);
InitRequestVar("db",0);
InitRequestVar("sd",$_SESSION["month_list"]);
InitRequestVar("ed",$_SESSION["month_list"]);
InitRequestVar("funds",0);

$params=array(
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':sd' => "'".$_REQUEST["sd"]."'",
	':ed' => "'".$_REQUEST["ed"]."'",
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':db' => $_REQUEST["db"],
	':fil' => $_REQUEST["fil"],
	':clusters' => $_REQUEST["clusters"],
	':login' => "'".$login."'",
);



//echo $is_fil;
/*
if (!isset($is_fil))
{
echo "TEST";
}
else
{
echo "TEST";
}
*/


$sql = rtrim(file_get_contents('sql/bud_svod_zatd_list.sql'));
$sql=stritr($sql,$params);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

//echo $sql;

foreach ($x as $k=>$v)
{
	$d['funds'][$v['fnd_kod']]['fund_name']=$v['fund_name'];
	$d['data'][$v['fil_id']]['head']['fil_name']=$v['fil_name'];
	$d['data'][$v['fil_id']][$v['fnd_kod']]=$v;
}


$sql = rtrim(file_get_contents('sql/bud_svod_zatd_list_tfil.sql'));
$sql=stritr($sql,$params);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($x as $k=>$v)
{
	$d['data'][$v['fil_id']]['total']=$v['total'];
	$d['data'][$v['fil_id']]['sales_fact']=$v['sales_fact'];
}


isset($d)?$smarty->assign('x', $d):null;

$sql = rtrim(file_get_contents('sql/bud_svod_zatd_list_total.sql'));
$sql=stritr($sql,$params);
$x = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('xt', $x);

$smarty->display('bud_svod_zatd_list.html');


//print_r($d);





?>