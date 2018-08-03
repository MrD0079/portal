<?
InitRequestVar("dates_list1",$now);
InitRequestVar("dates_list2",$now);
$params=array(
":dates_list1"=>"'".$_REQUEST["dates_list1"]."'",
":dates_list2"=>"'".$_REQUEST["dates_list2"]."'",
);
if (isset($_REQUEST["select"]))
{
$sql=rtrim(file_get_contents('sql/bud_ru_zay_info.sql'));
$sql=stritr($sql,$params);
//echo $sql;
//$_REQUEST["SQL"]=$sql;

//exit;
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d', $data);
}
$smarty->display('bud_ru_zay_info.html');
?>