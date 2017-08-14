<?
if (isset($_REQUEST["select_tasting"])){
    $sql = "SELECT t.*, TO_CHAR (t.dt, 'dd.mm.yyyy') dt FROM tasting t"
            . " WHERE dt >= TRUNC (SYSDATE) and program_id = '".$_REQUEST["id_program"]."'"
            . " and t.dt=to_date('".$_REQUEST["id_dt"]."','dd.mm.yyyy')";
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["select_tasting_program"])){
    $sql = "SELECT * FROM tasting_program ORDER BY name";
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["select_tasting_program_dates"])){
    $sql = "SELECT distinct TO_CHAR (t.dt, 'dd.mm.yyyy') dt FROM tasting t WHERE program_id = '".$_REQUEST["id_program"]."' ORDER BY dt";
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
} else if (isset($_REQUEST["select_time"])){
} else if (isset($_REQUEST["select_promoter_presence"])){
    $sql = "SELECT id, name FROM tasting_lists WHERE parent = (SELECT id FROM tasting_lists WHERE name = 'promoter_presence') ORDER BY name";
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["select_buyers_interest"])){
    $sql = "SELECT id, name FROM tasting_lists WHERE parent = (SELECT id FROM tasting_lists WHERE name = 'buyers_interest') ORDER BY name";
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["select_product_presence"])){
    $sql = "SELECT id, name FROM tasting_lists WHERE parent = (SELECT id FROM tasting_lists WHERE name = 'product_presence') ORDER BY name";
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["get_data"])){
    $sql = "SELECT * FROM tasting_tp WHERE  t_id = '".$_REQUEST["id_t"]."' AND tp= '".$_REQUEST["id_tp"]."'";
    //echo $sql;
    $r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    //print_r($r);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["save_data"])){
    $_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
    Table_Update('tasting_tp', array(
        "t_id"=>$_REQUEST["tasting"],
        "tp"=>$_REQUEST["tp"]
        ),$_REQUEST["tp_detail"]);
    //print_r($_REQUEST);
}
$smarty->display('tasting_control_list.html');