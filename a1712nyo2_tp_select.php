<?php
//audit("вошел в список сетей");

if (isset($_REQUEST["save"]))
{
    if (isset($_REQUEST["data"]))
    {
        foreach ($_REQUEST["data"] as $key => $val)
        {
            $keys = array('tp_kod'=>$key);
            $sql="
                SELECT COUNT (*)
                  FROM (select tp_kod FROM a1712nyo1_select
                        union
                        select tp_kod FROM a1712nyo3_select)
                 WHERE tp_kod = '".$key."'";
            $c=$db->getOne($sql);
            if ($c>0)
            {
                echo "<p>Данная накладная уже участвует в одной из акций!!!</p>";
            }
            else
            {
                Table_Update ("a1712nyo2_select", $keys, $val);
            }
        }
    }
    if (isset($_REQUEST["del"]))
    {
        foreach ($_REQUEST["del"] as $key => $val)
        {
            Table_Update ("a1712nyo2_select", array('tp_kod'=>$key), null);
        }
    }
}
$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn);
$sql=rtrim(file_get_contents('sql/a1712nyo2_tp_select.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp', $tp);
$sql=rtrim(file_get_contents('sql/a1712nyo2_tp_select_total.sql'));
$sql=stritr($sql,$params);
$tp = $db->getOne($sql);
$smarty->assign('tp_total', $tp);
$smarty->display('a1712nyo2_tp_select.html');
?>