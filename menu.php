<?
//audit("открыл главную страницу");

$sql=rtrim(file_get_contents('sql/akcii_local.sql'));
$params=array(':dpt_id'=>$_SESSION["dpt_id"],':tn'=>$tn);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);


foreach($data as $k=>$v)
{
$akcii_local[$v["y"]][$v["my"]]['mt']=$v['mt'];
$akcii_local[$v["y"]][$v["my"]]['data'][$v["fil"]]['fil_name']=$v['fil_name'];
$akcii_local[$v["y"]][$v["my"]]['data'][$v["fil"]]['data'][$v['id']]=$v;
}

/*
if ($_REQUEST["action"]=='menu'&&$_REQUEST["print"]==1)
{
echo "<pre>";
print_r($akcii_local);
echo "</pre>";
}
*/

isset($akcii_local)?$smarty->assign("akcii_local", $akcii_local):null;


$smarty->force_compile = true;
$smarty->display('menu.html');




?>