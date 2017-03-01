<?
audit("просмотрел лог посещений");
InitRequestVar("dates_list1",$_SESSION["month_list"]);
InitRequestVar("dates_list2",$now);
if (isset($_REQUEST["a14mega_make_good"]))
{
	audit("запустил процедуру исправления a14mega","get_data");
	$sql = rtrim(file_get_contents('sql/a14mega_make_good.sql'));
	$res = $db->Query($sql);
}
if (isset($_REQUEST["start_job"]))
{
	audit("запустил процедуру закачки данных из SW","get_data");
	$sql = rtrim(file_get_contents('sql/get_data.sql'));
	$res = $db->Query($sql);
}
if (isset($_REQUEST["clear_log"])&&isset($_REQUEST["prg"]))
{
	$sql = "delete from full_log where prg='".$_REQUEST["prg"]."'";
	$res = $db->Query($sql);
	$_REQUEST["select"]='select';
}
if (isset($_REQUEST["select"]))
{
	$sql = rtrim(file_get_contents('sql/log.sql'));
	!isset($_REQUEST["prg"])?$_REQUEST["prg"]=null:null;
	$params = array(
	':prg' => "'".$_REQUEST["prg"]."'",
	":dates_list1"=>"'".$_REQUEST["dates_list1"]."'",
	":dates_list2"=>"'".$_REQUEST["dates_list2"]."'"
	);
        $sql=stritr($sql,$params);
        //echo $sql;
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('log', $res);
}
$smarty->display('log.html');
?>