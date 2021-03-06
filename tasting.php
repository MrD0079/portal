<?
if (isset($_REQUEST["get_tp"])){
    $sql = "SELECT t.t_id,
       t.time_start,
       t.time_end,
       t.svms,
       t.new_controller,
       n.net_name,
       tz_oblast || ' ' || c.ur_tz_name || ' ' || c.tz_address tp_name,
       utmkk.fio tmkk_fio,
       usvms.fio svms_fio,
       (SELECT COUNT (*)
          FROM tasting_promoter
         WHERE t_id = t.t_id AND tp = t.tp)
          promoter_cnt,
       c.kodtp tp,
       (SELECT fio
          FROM user_list
         WHERE tn = t.new_controller)
          new_controller_fio,t.extra_hours_payment
  FROM tasting_tp t,
       ms_nets n,
       cpp c,
       user_list utmkk,
       user_list usvms
 WHERE     t.t_id(+) = '".$_REQUEST["id"]."'
       AND t.tp(+) = c.kodtp
       AND c.id_net = n.id_net
       AND n.tn_tmkk = utmkk.tn(+)
       AND t.svms = usvms.tn(+)
       AND c.kodtp = '".$_REQUEST["tp"]."'";
    $r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["list_tp"])){
    $sql = "select tp from tasting_tp where t_id='".$_REQUEST["id"]."'";
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["select_tasting_program"])){
    $sql = "SELECT * FROM tasting_program ORDER BY name";
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["select_svms"])){
    $sql = "SELECT tn, fio FROM user_list WHERE pos_id = 127707110 AND datauvol IS NULL ORDER BY fio";
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["select_nets"])){
    $sql = rtrim(file_get_contents('sql/ms_nets.sql'));
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["select_tp"])){
    $sql = "SELECT c.*
    FROM cpp c
    WHERE c.id_net = '".$_REQUEST["id_net"]."' AND c.id_net <> 0
    ORDER BY tz_oblast NULLS FIRST, ur_tz_name, tz_address";
    echo $sql;
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["list_tasting"])){
    $sql = "
                SELECT t.*,
                TO_CHAR (t.dt, 'dd.mm.yyyy') dt,
                (SELECT COUNT (*)
                FROM tasting_tp
                WHERE t_id = t.id)
                tp_cnt,
                p.name tasting_program_name
                FROM tasting t, tasting_program p
                WHERE t.program_id = p.id(+)
                ORDER BY p.name, t.dt
            ";
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["save_tasting"])){
    $_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
    isset($_REQUEST["tasting"]["dt"])?$_REQUEST["tasting"]["dt"]=OraDate2MDBDate($_REQUEST["tasting"]['dt']):null;
    Table_Update('tasting', array("id"=>$_REQUEST["id"]),$_REQUEST["tasting"]);
    if (!isset($_REQUEST["tasting_tp"])){
        Table_Update('tasting_tp', array("t_id"=>$_REQUEST["id"]),null);
    } else {
        $r = $db->getCol("select tp from tasting_tp where t_id=".$_REQUEST["id"], null, null, null, 0);
        $delete = array_diff(array_values($r),array_keys($_REQUEST["tasting_tp"]));
        foreach ($delete as $k=>$v){
            Table_Update('tasting_tp', array("t_id"=>$_REQUEST["id"],"tp"=>$v),null);
        }
        foreach ($_REQUEST["tasting_tp"] as $k=>$v){
            Table_Update('tasting_tp', array("t_id"=>$_REQUEST["id"],"tp"=>$k),$v);
        }
    }
} else if (isset($_REQUEST["id"])||isset($_REQUEST["new_tasting"])){
    !isset($_REQUEST["id"])?$_REQUEST["id"]=get_new_id():null;
    $sql = "SELECT t.*, TO_CHAR (t.dt, 'dd.mm.yyyy') dt, p.name program_name
  FROM tasting t, tasting_program p
 WHERE t.program_id = p.id AND t.id = '".$_REQUEST["id"]."'";
    $r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('tasting', $r);
}
$smarty->display('tasting.html');