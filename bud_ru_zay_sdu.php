<?
//ses_req();


$sql=rtrim(file_get_contents('sql/bud_ru_zay_sdu_sales_get_tp_type.sql'));
$params=array(':z_id' => $_REQUEST["z_id"]);
$sql=stritr($sql,$params);
$tp_type = $db->getOne($sql);

$sql=rtrim(file_get_contents('sql/bud_ru_zay_sdu_sales_'.$tp_type.'.sql'));
$params=array(':z_id' => $_REQUEST["z_id"]);
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach($d as $k=>$v){
	$d1[$v['tp_kod']]['data'][$k]=$v;
	$d1[$v['tp_kod']]['head']['tp_ur']=$v['tp_ur'];
	$d1[$v['tp_kod']]['head']['tp_addr']=$v['tp_addr'];
}
isset($d1)?$smarty->assign('sales', $d1):null;

$sql=rtrim(file_get_contents('sql/bud_ru_zay_sdu_sales_'.$tp_type.'_total.sql'));
$params=array(':z_id' => $_REQUEST["z_id"]);
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach($d as $k=>$v){
	//$d2['data'][$k]=$v;
	$smarty->assign('cnt', $v['cnt']);
}
//print_r($d2);
//isset($d2)?$smarty->assign('sales_t', $d2):null;
$smarty->assign('sales_t', $d);

$sql=rtrim(file_get_contents('sql/bud_ru_zay_get_head.sql'));
$p=array(':z_id' => $_REQUEST["z_id"]);
$sql=stritr($sql,$p);
$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$sql=rtrim(file_get_contents('sql/bud_ru_zay_get_ff.sql'));
$p=array(':z_id' => $_REQUEST["z_id"]);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach ($data as $k1=>$v1)
{
	if ($v1["type"]=="file")
	{
		$data[$k1]["val_file"]=explode("\n",$v1["val_file"]);
	}
}
include "bud_ru_zay_formula.php";
$d["ff"]=$data;
$smarty->assign('z', $d);

//$tn=$_REQUEST["tn"];

$sql=rtrim(file_get_contents('sql/bud_ru_zay_sdu_goals.sql'));
$params=array(':z_id' => $_REQUEST["z_id"]);
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//echo $sql;
//print_r($data);
$smarty->assign('goals', $d);

$sql=rtrim(file_get_contents('sql/bud_ru_zay_sdu_goals_max0id.sql'));
$params=array(':z_id' => $_REQUEST["z_id"]);
$sql=stritr($sql,$params);
$goals_max0id = $db->getOne($sql);
$smarty->assign('goals_max0id', $goals_max0id);

foreach ($d as $k=>$v)
{
	$sql=rtrim(file_get_contents('sql/bud_ru_zay_get_ff.sql'));
	$p=array(':z_id' => $v["id"]);
	$sql=stritr($sql,$p);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($data as $k1=>$v1)
	{
		if ($v1["type"]=="file")
		{
			$data[$k1]["val_file"]=explode("\n",$v1["val_file"]);
		}
		$ff[$v1['ff_id']]=$v1['name'];
	}
	include "bud_ru_zay_formula.php";
	$d[$k]["ff"]=$data;
}

isset($ff) ? $smarty->assign('ff', $ff) : null;
isset($d) ? $smarty->assign('d', $d) : null;


$smarty->display('bud_ru_zay_sdu.html');

?>