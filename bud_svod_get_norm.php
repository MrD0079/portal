<?

InitRequestVar("dt",$_SESSION["month_list"]);

$params=array(
	':dt' => "'".$_REQUEST["dt"]."'",
	':dpt_id' => $_SESSION["dpt_id"],
);

$sql = rtrim(file_get_contents('sql/bud_svod_get_norm.sql'));
$sql=stritr($sql,$params);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($x as $k=>$v)
{
	$smarty->assign('norm_'.$v['kod'], $v['norm']);
}

?>