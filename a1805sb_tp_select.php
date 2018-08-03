<?php
//audit("вошел в список сетей");

if (isset($_REQUEST["save"]))
{
    if (isset($_REQUEST["data"]))
    {
        foreach ($_REQUEST["data"] as $key => $val)
        {
            $keys = array('tp_kod'=>$key);
            Table_Update ("a1805sb_tp_select", $keys, $val);
        }
    }
    if (isset($_REQUEST["del"]))
    {
        foreach ($_REQUEST["del"] as $key => $val)
        {
            Table_Update ("a1805sb_tp_select", array('tp_kod'=>$key), null);
        }
    }
}
$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn);
$sql=rtrim(file_get_contents('sql/a1805sb_tp_select.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp', $tp);
$sql_total=rtrim(file_get_contents('sql/a1805sb_tp_select_total.sql'));
$sql_total=stritr($sql_total,$params);
$tp_total = $db->getOne($sql_total);
$smarty->assign('tp_total', $tp_total);
$smarty->display('a1805sb_tp_select.html');
?>