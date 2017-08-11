<?
if (isset($_REQUEST["select_tasting"])){
    $sql = "SELECT t.*, TO_CHAR (t.dt, 'dd.mm.yyyy') dt FROM tasting t";
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["select_nets"])){
    $sql = "  SELECT DISTINCT n.id_net, n.net_name
    FROM tasting_tp t, ms_nets n, cpp c
    WHERE t.t_id = '".$_REQUEST["id_t"]."' AND t.tp = c.kodtp AND c.id_net = n.id_net
    ORDER BY n.net_name";
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["select_tp"])){
    $sql = "  SELECT DISTINCT c.*
    FROM tasting_tp t, ms_nets n, cpp c
    WHERE     t.t_id = '".$_REQUEST["id_t"]."'
         AND t.tp = c.kodtp
         AND c.id_net = n.id_net
         AND n.id_net = '".$_REQUEST["id_net"]."'
    ORDER BY n.net_name";
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["select_new_controller"])){
    $sql = "SELECT tn,
         fio,
         pos_id,
         pos_name,
         is_mkk,
         is_mkk_new,
         is_tm
    FROM user_list
   WHERE  (  is_tm = 1
         OR pos_id IN (69)
         OR     (    1 IN (is_mkk, is_mkk_new)
                 AND tn IN (SELECT slave
                              FROM full
                             WHERE master =
                                      (SELECT n.tn_tmkk
                                         FROM ms_nets n, cpp c
                                        WHERE     c.id_net = n.id_net
                                              AND c.kodtp = '".$_REQUEST["id_tp"]."')))
            )
            AND datauvol IS NULL AND '".$_REQUEST["id_tp"]."' <> 0
ORDER BY fio";
    echo $sql;
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["save_controller"])){
    $_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
    Table_Update('tasting_tp', array(
        "t_id"=>$_REQUEST["tasting"],
        "tp"=>$_REQUEST["tp"]
        ),array("new_controller"=>$_REQUEST["new_controller"]));
    //print_r($_REQUEST);
    //print_r($_FILES);
}
$smarty->display('tasting_controller.html');