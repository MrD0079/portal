<?
if (isset($_REQUEST["new_name"]))
{
    if ($_REQUEST["new_name"]!='')
    {
        Table_Update("ms_task_status",array("name"=>$_REQUEST["new_name"]),array("name"=>$_REQUEST["new_name"]));
    }
}
if (isset($_REQUEST["update"]))
{
    foreach ($_REQUEST["update"] as $k=>$v)
    {
        $keys=array("id"=>$k);
        $values=$v;
        Table_Update("ms_task_status",$keys,$values);
    }
}
if (isset($_REQUEST["delete"]))
{
    foreach ($_REQUEST["delete"] as $k=>$v)
    {
        $keys=array("id"=>$k);
        Table_Update("ms_task_status",$keys,null);
    }
}
$sql=rtrim(file_get_contents('sql/ms_task_status.sql'));
$ms_task_status = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ms_task_status', $ms_task_status);
$smarty->display('ms_task_status.html');
?>