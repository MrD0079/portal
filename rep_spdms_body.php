<?
InitRequestVar("month_list",$_SESSION["month_list"]);
$p = array(":month_list" => "'".$_REQUEST["month_list"]."'",":tn"=>$_REQUEST["tn"]);
$sql = rtrim(file_get_contents('sql/rep_spdms_body.sql'));
$sql=stritr($sql,$p);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$sqlu = rtrim(file_get_contents('sql/rep_spdms_body_ag.sql'));
foreach ($r as $k=>$v)
{
$p[":visitdate"] = "'".$v["visitdate_txt"]."'";
$p[":tp_kod"] = $v["tp_kod"];
$r[$k]['agents'] = $db->getAll(stritr($sqlu,$p), null, null, null, MDB2_FETCHMODE_ASSOC);
}
$smarty->assign('list', $r);
//print_r($r);
$smarty->assign('spd_fio', $db->getOne('select fio from rep_spdms_list where tn='.$_REQUEST['tn']));
$smarty->assign('period', $db->getOne('SELECT mt || \' \' || y FROM calendar WHERE data = TO_DATE (\''.$_REQUEST['month_list'].'\', \'dd.mm.yyyy\')'));
$smarty->display('rep_spdms_body.html');
?>