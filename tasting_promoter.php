<?
if (isset($_REQUEST["get_promoter"])){
    $params=array(':id' => $_REQUEST["id_t"], ':tp' => $_REQUEST["id_tp"],':promoter'=>"'".$_REQUEST["promoter"]."'");
    //$sql = "SELECT t.* FROM tasting_promoter t WHERE t.t_id = :id AND t.tp = :tp";
    $sql = "SELECT fio from spr_users_ms where login = :promoter";
    $sql = stritr($sql,$params);
    //echo $sql;
    //$r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $r = $db->getOne($sql);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["list_promoter"])){
    $sql = "select promoter from tasting_promoter where t_id='".$_REQUEST["id_t"]."' and tp='".$_REQUEST["id_tp"]."'";
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["select_tasting"])){
    $sql = "SELECT t.*, TO_CHAR (t.dt, 'dd.mm.yyyy') dt FROM tasting t"
            . " WHERE /*dt >= TRUNC (SYSDATE) and*/ program_id = '".$_REQUEST["id_program"]."'"
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
    $sql = "SELECT DISTINCT n.id_net, n.net_name
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
} else if (isset($_REQUEST["select_promoter"])){
    $sql="SELECT login, fio
    FROM spr_users_ms
   WHERE pos_id IN (127968517) AND datauvol IS NULL AND '".$_REQUEST["id_tp"]."' <> 0
ORDER BY fio";
    //echo $sql;
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["save_promoter"])){
    $_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
    if (!isset($_REQUEST["tasting_promoter"])){
        Table_Update('tasting_promoter', array("t_id"=>$_REQUEST["tasting"],"tp"=>$_REQUEST["tp"]),null);
    } else {
        $r = $db->getCol("select promoter from tasting_promoter where t_id=".$_REQUEST["tasting"]." and tp=".$_REQUEST["tp"], null, null, null, 0);
        $delete = array_diff(array_values($r),array_keys($_REQUEST["tasting_promoter"]));
        foreach ($delete as $k=>$v){
            //echo $k."===".$v;
            $keys = array("t_id"=>$_REQUEST["tasting"],"tp"=>$_REQUEST["tp"],"promoter"=>$v);
            Table_Update('tasting_promoter', $keys, null);
        }
        foreach ($_REQUEST["tasting_promoter"] as $k=>$v){
            //echo $k."===".$v;
            $keys = array("t_id"=>$_REQUEST["tasting"],"tp"=>$_REQUEST["tp"],"promoter"=>$v);
            Table_Update('tasting_promoter', $keys, $keys);
        }
    }
    /*Table_Update('tasting_promoter', array(
        "t_id"=>$_REQUEST["tasting"],
        "tp"=>$_REQUEST["tp"]
        ),array("new_promoter"=>$_REQUEST["new_promoter"]));*/
    //print_r($_REQUEST);
    //print_r($_FILES);
}

$smarty->display('tasting_promoter.html');