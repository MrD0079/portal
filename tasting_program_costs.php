<?
if (isset($_REQUEST["select_tasting_program"])){
    $sql = "SELECT * FROM tasting_program ORDER BY name";
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["report_user"])){
    $sql = "SELECT nvl(tpc.motivation,0)
       + nvl(tpc.transportation_costs,0)
       + nvl(tpc.log_trasport,0)
       + nvl(tpc.log_loaders,0)
       + nvl(tpc.log_lease_warehouse,0)
       + nvl(tpc.organizational_costs,0)
       + nvl(tpc.consumables,0)
       + nvl(tpc.bank_services,0)
       + nvl(tpc.transportation_costs * u.amort,0)
          costs_amount, tpc.*,u.chief_tn FROM tasting_program_costs tpc, user_list u WHERE tpc.login = u.login AND tpc.program_id = '".$_REQUEST["program_id"]."' and tpc.login='".$_REQUEST["login"]."'";
    $r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    //echo $sql;
    $smarty->assign('x', $r);
    $smarty->assign('program_name', $db->getOne("SELECT name FROM tasting_program WHERE id = '".$_REQUEST["program_id"]."'"));
    $smarty->assign('login_fio', $db->getOne("SELECT fio FROM user_list WHERE login = '".$_REQUEST["login"]."'"));
    $smarty->assign('amort', $db->getOne("SELECT amort FROM user_list WHERE login = '".$_REQUEST["login"]."'"));
    $smarty->assign('program_readonly', $db->getOne("SELECT closed FROM tasting_program WHERE id = '".$_REQUEST["program_id"]."'"));
} else if (isset($_REQUEST["report_promo"])){
    $sql = "SELECT nvl(tpc.motivation,0)
       + nvl(tpc.transportation_costs,0)
       + nvl(tpc.log_trasport,0)
       + nvl(tpc.log_loaders,0)
       + nvl(tpc.log_lease_warehouse,0)
       + nvl(tpc.organizational_costs,0)
       + nvl(tpc.consumables,0)
       + nvl(tpc.bank_services,0)
       + nvl(tpc.transportation_costs * u.amort,0)
          costs_amount, tpc.*,u.chief_tn FROM tasting_program_costs tpc, user_list u WHERE tpc.login = u.login AND tpc.program_id = '".$_REQUEST["program_id"]."' and tpc.login='".$_REQUEST["login"]."'";
    $r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
    $smarty->assign('program_name', $db->getOne("SELECT name FROM tasting_program WHERE id = '".$_REQUEST["program_id"]."'"));
    $smarty->assign('login_fio', $db->getOne("SELECT fio FROM user_list WHERE login = '".$_REQUEST["login"]."'"));
    $smarty->assign('program_readonly', $db->getOne("SELECT closed FROM tasting_program WHERE id = '".$_REQUEST["program_id"]."'"));
} else if (isset($_REQUEST["getFiles"])){
    $sql = "SELECT tpc.*,u.chief_tn FROM tasting_program_costs tpc, user_list u WHERE tpc.login = u.login AND tpc.program_id = '".$_REQUEST["program_id"]."' and tpc.login='".$_REQUEST["login"]."'";
    $r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    //echo $sql;
    $smarty->assign('x', $r);
    $smarty->assign('program_readonly', $db->getOne("SELECT closed FROM tasting_program WHERE id = '".$_REQUEST["program_id"]."'"));
} else if (isset($_REQUEST["get_data"])){
    $smarty->assign('program_name', $db->getOne("SELECT name FROM tasting_program WHERE id = '".$_REQUEST["program_id"]."'"));
    $smarty->assign('program_readonly', $db->getOne("SELECT closed FROM tasting_program WHERE id = '".$_REQUEST["program_id"]."'"));
    $smarty->assign('period',$db->getRow("SELECT TO_CHAR (MIN (dt), 'dd.mm.yyyy') min_dt, TO_CHAR (MAX (dt), 'dd.mm.yyyy') max_dt FROM tasting t WHERE t.program_id = '".$_REQUEST["program_id"]."'", null, null, null, MDB2_FETCHMODE_ASSOC));
    $sql = "SELECT tpc.program_id,
        tpc.login,
         nvl(tpc.motivation,0)
       + nvl(tpc.transportation_costs,0)
       + nvl(tpc.log_trasport,0)
       + nvl(tpc.log_loaders,0)
       + nvl(tpc.log_lease_warehouse,0)
       + nvl(tpc.organizational_costs,0)
       + nvl(tpc.consumables,0)
       + nvl(tpc.bank_services,0)
       + nvl(tpc.transportation_costs * u.amort,0)
          costs_amount,
       tpc.is_accepted,
       tpc.is_processed,
       u.fio,
       u.pos_name,
       u.chief_tn,
       u.chief_fio,
        motivation_files           ,
        transportation_costs_files ,
        log_trasport_files         ,
        log_loaders_files          ,
        log_lease_warehouse_files  ,
        organizational_costs_files ,
        consumables_files          ,
        bank_services_files,
        files,
NVL (REGEXP_COUNT (motivation_files, '[' || CHR (10) || ']') + 1, 0) +
NVL (REGEXP_COUNT (transportation_costs_files, '[' || CHR (10) || ']') + 1, 0) +
NVL (REGEXP_COUNT (log_trasport_files, '[' || CHR (10) || ']') + 1, 0) +
NVL (REGEXP_COUNT (log_loaders_files, '[' || CHR (10) || ']') + 1, 0) +
NVL (REGEXP_COUNT (log_lease_warehouse_files, '[' || CHR (10) || ']') + 1, 0) +
NVL (REGEXP_COUNT (organizational_costs_files, '[' || CHR (10) || ']') + 1, 0) +
NVL (REGEXP_COUNT (consumables_files, '[' || CHR (10) || ']') + 1, 0) +
NVL (REGEXP_COUNT (bank_services_files, '[' || CHR (10) || ']') + 1, 0) +
NVL (REGEXP_COUNT (files, '[' || CHR (10) || ']') + 1, 0) files_count,
         motivation,
         transportation_costs,
         log_trasport,
         log_loaders,
         log_lease_warehouse,
         organizational_costs,
         consumables,
         bank_services,
         transportation_costs * u.amort amort
  FROM tasting_program_costs tpc, user_list u
 WHERE tpc.login = u.login AND tpc.program_id =  '".$_REQUEST["program_id"]."'   AND (   u.tn = ".$tn."
              OR u.chief_tn IN (SELECT slave
                                  FROM full
                                 WHERE master = ".$tn.")
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = ".$tn.") = 1
              OR (SELECT NVL (is_acceptor, 0)
                    FROM user_list
                   WHERE tn = ".$tn.") = 1) order by u.chief_fio, u.fio";
    //echo $sql;
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
    $smarty->assign('costs_amount', $db->getOne("SELECT SUM (
            nvl(tpc.motivation,0)
          + nvl(tpc.transportation_costs,0)
          + nvl(tpc.log_trasport,0)
          + nvl(tpc.log_loaders,0)
          + nvl(tpc.log_lease_warehouse,0)
          + nvl(tpc.organizational_costs,0)
          + nvl(tpc.consumables,0)
          + nvl(tpc.bank_services,0)
          + nvl(tpc.transportation_costs * u.amort,0)
          )
         costs_amount
  FROM tasting_program_costs tpc, user_list u
 WHERE tpc.login = u.login AND tpc.program_id = '".$_REQUEST["program_id"]."'   AND (   u.tn = ".$tn."
              OR u.chief_tn IN (SELECT slave
                                  FROM full
                                 WHERE master = ".$tn.")
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = ".$tn.") = 1
              OR (SELECT NVL (is_acceptor, 0)
                    FROM user_list
                   WHERE tn = ".$tn.") = 1) "));
    $smarty->assign('promoters', $db->getAll("SELECT login, fio FROM user_list WHERE pos_id = 127968517 AND chief_tn = ".$tn, null, null, null, MDB2_FETCHMODE_ASSOC));
} else if (isset($_REQUEST["save_user_report"])){
    $_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
    Table_Update('tasting_program_costs', $_REQUEST["keys"],$_REQUEST["vals"]);
    
    $_FILES = recursive_iconv ('UTF-8', 'Windows-1251', $_FILES);
    foreach ($_FILES as $key => $value)
    {
        if (isset($value))
        {
            foreach($value['tmp_name'] as $k=>$v){
                if (is_uploaded_file($value['tmp_name'][$k]))
                {
                        $a=pathinfo($value['name'][$k]);
                        $id=get_new_file_id();
                        $fn=$id.'_'.translit($value['name'][$k]);
                        $files = $db->getOne("SELECT ".$key." FROM tasting_program_costs WHERE program_id = '".$_REQUEST["keys"]["program_id"]."' and login='".$_REQUEST["keys"]["login"]."'");
                        $files = preg_split('/\r\n|\r|\n/', $files);
                        $files[]=$fn;
                        $vals = array($key=>join("\n",$files));
                        Table_Update('tasting_program_costs', $_REQUEST["keys"],$vals);
                        move_uploaded_file($value['tmp_name'][$k], 'files/'.$fn);
                }
            }
        }
    }
    if (isset($_REQUEST["del_files"])) {
        foreach ($_REQUEST["del_files"] as $k1 => $v1) {
            foreach($v1 as $k => $v) {
                $files = $db->getOne("SELECT ".$k1." FROM tasting_program_costs WHERE program_id = '".$_REQUEST["keys"]["program_id"]."' and login='".$_REQUEST["keys"]["login"]."'");
                $files = preg_split('/\r\n|\r|\n/', $files);
                if(($k2 = array_search($k, $files)) !== false) {unset($files[$k2]);}
                $vals = array($k1=>join("\n",$files));
                Table_Update('tasting_program_costs', $_REQUEST["keys"],$vals);
            }
        }
    }
} else if (isset($_REQUEST["del_rep"])){
    Table_Update('tasting_program_costs', $_REQUEST["keys"],null);
} else if (isset($_REQUEST["send_msg"])){
    $_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
    Table_Update('tasting_program_costs', $_REQUEST["keys"],array('msg'=>$_REQUEST["msg"]));
    $program_name = $db->getOne("select name from tasting_program where id=".$_REQUEST["keys"]["program_id"]);
    if ($_REQUEST["keys"]["login"]==$login){
        $email = $db->getOne("select e_mail from user_list where tn=(select chief_tn from user_list where login='".$_REQUEST["keys"]["login"]."')");
    } else {
        $email = $db->getOne("select e_mail from user_list where login='".$_REQUEST["keys"]["login"]."'");
    }
    send_mail($email, "����������� �� ������ � �������� �� ���������� \"".$program_name."\"", $_REQUEST["msg"]);
}
$smarty->display('tasting_program_costs.html');