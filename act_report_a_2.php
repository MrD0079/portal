<?php

if (isset($_REQUEST["generate"]))
{
$sql=rtrim(file_get_contents("sql/".$_REQUEST['act']."_report_a.sql"));
$sql=stritr($sql,$params);
//echo $sql;
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign("list", $list);
}

?>