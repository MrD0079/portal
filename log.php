<?
audit("просмотрел лог посещений");
InitRequestVar("dates_list1",$_SESSION["month_list"]);
InitRequestVar("dates_list2",$now);
InitRequestVar("log_r1",1);
InitRequestVar("log_r2",1000);
isset($_REQUEST["table"])?$table=$_REQUEST["table"]:$table="full_log";
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
        isset($_REQUEST["table"])
        ?
        $sql = "delete from ".$table
        :
        $sql = "delete from ".$table." where prg='".$_REQUEST["prg"]."'";
	$res = $db->Query($sql);
	$_REQUEST["select"]='select';
}
if (isset($_REQUEST["select"]))
{
	$sql = rtrim(file_get_contents('sql/'.$table.'.sql'));
	!isset($_REQUEST["prg"])?$_REQUEST["prg"]=null:null;
	$params = array(
	':table' => $table,
	':prg' => "'".$_REQUEST["prg"]."'",
	":dates_list1"=>"'".$_REQUEST["dates_list1"]."'",
	":dates_list2"=>"'".$_REQUEST["dates_list2"]."'",
	':r1' => $_REQUEST["log_r1"],
	':r2' => $_REQUEST["log_r2"],
	);
        $sql=stritr($sql,$params);
        //echo $sql;
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('log', $res);
}
$smarty->display('log.html');
//ses_req();
?>