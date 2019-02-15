<?php
//audit("????? ? ?????? ?????");

if (isset($_REQUEST["save"]))
{
    if (isset($_REQUEST["data"]))
    {
        foreach ($_REQUEST["data"] as $key => $val)
        {
            /* check if this TP is already saved in another plan in this promotion */
            $params[':tp_kod'] = $key;
            $sql = 'SELECT count(*)  cnt FROM (
                      SELECT COUNT(*) cnt
                      FROM PERSIK.a1902gm1_select gm1
                      WHERE gm1.tp_kod = :tp_kod
                        UNION
                      SELECT COUNT(*) cnt
                      FROM PERSIK.a1902gm3_select gm3
                      WHERE gm3.tp_kod = :tp_kod
                    ) WHERE cnt = 1';
            $sql=stritr($sql,$params);
            $is_already_added = $db->getOne($sql);

            if($is_already_added == 0){
                $keys = array('tp_kod'=>$key);
                Table_Update ("a1902gm2_SELECT", $keys, $val);
            }else{
                /* show message that TP is already added in other plans in this promotion */
                echo "<span style='color:red;'>ТП ".$key." уже выбрана в другом плане</span><br>";
            }
        }
    }
    if (isset($_REQUEST["del"]))
    {
        foreach ($_REQUEST["del"] as $key => $val)
        {
            Table_Update ("a1902gm2_SELECT", array('tp_kod'=>$key), null);
        }
    }
}
$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn);
$sql=rtrim(file_get_contents('sql/a1902gm2_tp_select.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp', $tp);
$sql_total=rtrim(file_get_contents('sql/a1902gm2_tp_select_total.sql'));
$sql_total=stritr($sql_total,$params);
$tp_total = $db->getOne($sql_total);
$smarty->assign('tp_total', $tp_total);
$smarty->display('a1902gm2_tp_select.html');
?>