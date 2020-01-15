<?php

if (isset($_REQUEST["save"]))
{
    if (isset($_REQUEST["data"]))
    {
        foreach ($_REQUEST["data"] as $key => $val)
        {
            $keys = array('tp_kod'=>$key);

            $sql="SELECT COUNT (*)
                    FROM (
                            select TP_KOD FROM A1912HC1_ACTION_NAKL
                        )
                    WHERE TP_KOD = '".$key."'";
            $c=$db->getOne($sql);

            if ($c>0) {
                echo "<p style='color: red;'>Клиент ".$key." уже участвует в акции 'Праздник приближается 3+1' (усл. 1). Выдачу бонуса по условию 2 необходимо оформить через СЗ.</p>";
            }else {
                Table_Update ($_REQUEST['act']."_SELECT", $keys, $val);
            }

        }
    }
    if (isset($_REQUEST["del"]))
    {
        foreach ($_REQUEST["del"] as $key => $val)
        {
            Table_Update ($_REQUEST['act']."_SELECT", array('tp_kod'=>$key), null);
        }
    }
}
$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn);
$sql=rtrim(file_get_contents('sql/'.$_REQUEST['act'].'_tp_select.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp', $tp);
$sql_total=rtrim(file_get_contents('sql/'.$_REQUEST['act'].'_tp_select_total.sql'));
$sql_total=stritr($sql_total,$params);
$tp_total = $db->getOne($sql_total);
$smarty->assign('tp_total', $tp_total);
$smarty->display($_REQUEST['act'].'_tp_select.html');
?>