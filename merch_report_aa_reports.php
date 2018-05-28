<?
if (isset($_REQUEST["getReport"])){
    $p = array(
        ":sd"=>"'".$_REQUEST["sd"]."'",
        ":ed"=>"'".$_REQUEST["ed"]."'",
        ":ag_id"=>$_REQUEST["agent"],
        ":tn"=>$tn,
        ":activity"=>$_REQUEST["activity"],":login"=>"'".$login."'"
    );
    $sql="/* Formatted on 22.04.2018 19:03:19 (QP5 v5.252.13127.32867) */
  SELECT plan.tz_address,
         plan.fio,
         plan.kodtp,
         SUM (NVL (fakt.fakt_mr, 0)) visit_fakt,
         MAX (aa.started) started,
         MAX (aa.aa_id) aa_id,
         MAX (DECODE (aa.lu, NULL, NULL, 1)) report_exists
    FROM (SELECT c.data,
                 u.fio,
                 rh.id head_id,
                 rh.num,
                 rh.fio_otv,
                 n.net_name,
                 ur_tz_name,
                 tz_address,
                 rb.kodtp,
                 rb.vv,
                 rb.id rb_id,
                 rb.day_TIME_MR plan_minutes,
                 CASE WHEN rb.day_TIME_MR > 0 THEN 1 ELSE 0 END plan_mr
            FROM routes_body1 rb,
                 routes_head rh,
                 routes_head_agents rha,
                 routes_tp rt,
                 cpp cpp1,
                 svms_oblast s,
                 ms_nets n,
                 (SELECT DISTINCT data, dm FROM calendar) c,
                 user_list u,
                 merch_report_cal_aa_h h
           WHERE     c.data BETWEEN h.dts AND h.dte
                 AND h.id = :activity
                 AND rh.data = TRUNC (c.data, 'mm')
                 AND u.tn = rh.tn
                 AND rb.day_num = c.dm
                 AND rh.id = rb.head_id
                 AND rh.id = rha.head_id
                 AND rha.ag_id = rb.ag_id
                 AND rh.id = rt.head_id
                 AND rb.kodtp = rt.kodtp
                 AND rh.tn = s.tn
                 AND (   rh.tn IN (SELECT slave
                                     FROM full
                                    WHERE master = :tn UNION
                        SELECT chief
                          FROM spr_users_ms
                         WHERE     login = :login
                               AND (SELECT is_smr
                                      FROM user_list
                                     WHERE login = :login) = 1)
                      OR (SELECT is_admin
                            FROM user_list
                           WHERE tn = :tn) = 1
                      OR (SELECT is_ma
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND rb.vv = rha.vv
                 AND rha.vv = rt.vv
                 AND cpp1.tz_oblast = s.oblast
                 AND cpp1.kodtp = rb.kodtp
                 AND cpp1.kodtp = rt.kodtp
                 AND n.id_net = cpp1.id_net
                 AND rha.ag_id = :ag_id
                 AND (rb.DAY_enabled_MR = 1)) plan,
         (SELECT mr.dt,
                 mr.rb_id,
                 MR_FAKT fakt_minutes,
                 CASE WHEN MR_FAKT > 0 THEN 1 END fakt_mr
            FROM merch_report mr,
                 routes_body1 rb,
                 routes_head rh,
                 routes_head_agents rha,
                 routes_tp rt,
                 cpp cpp1,
                 svms_oblast s,
                 ms_nets n,
                 (SELECT DISTINCT data, dm FROM calendar) c,
                 merch_report_ok mro,
                 merch_report_cal_aa_h h
           WHERE     c.data BETWEEN h.dts AND h.dte
                 AND h.id = :activity
                 AND rh.data = TRUNC (c.data, 'mm')
                 AND mr.dt = c.data
                 AND rb.day_num = c.dm
                 AND rb.id = mr.rb_id
                 AND rh.id = rb.head_id
                 AND rh.id = rha.head_id
                 AND rha.ag_id = rb.ag_id
                 AND rh.id = rt.head_id
                 AND rb.kodtp = rt.kodtp
                 AND rh.tn = s.tn
                 AND rb.vv = rha.vv
                 AND rha.vv = rt.vv
                 AND cpp1.tz_oblast = s.oblast
                 AND cpp1.kodtp = rb.kodtp
                 AND cpp1.kodtp = rt.kodtp
                 AND n.id_net = cpp1.id_net
                 AND rha.ag_id = :ag_id
                 AND (  NVL (
                           (SELECT id
                              FROM merch_report_vv
                             WHERE     head_id = rh.id
                                   AND ag_id = rha.ag_id
                                   AND kod_tp = cpp1.kodtp
                                   AND dt = mr.dt),
                           0)
                      + rb.vv <> 1)
                 AND (rb.DAY_enabled_MR = 1)
                 AND mro.dt = mr.dt
                 AND mro.head_id = rh.id) fakt,
         MERCH_REPORT_CAL_REMINDERS r,
         MERCH_REPORT_CAL_AA_H aa_h,
         merch_report_aa_report aa
   WHERE     plan.data = fakt.dt(+)
         AND plan.rb_id = fakt.rb_id(+)
         AND plan.data = r.data
         AND plan.head_id = r.head_id
         AND :ag_id = r.ag_id
         AND plan.kodtp = r.kodtp
         AND r.aa_id = aa_h.id
         AND :ag_id = aa.ag_id(+)
         AND plan.kodtp = aa.kodtp(+)
         AND r.aa_id = :activity
         AND :activity = aa.aa_id(+)
GROUP BY plan.tz_address,
         plan.fio,
         plan.kodtp
ORDER BY tz_address, fio";
    $sql=stritr($sql,$p);
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
    
    $sql="/* Formatted on 22.04.2018 19:18:52 (QP5 v5.252.13127.32867) */
SELECT DISTINCT aa.photo, plan.tz_address
  FROM (SELECT c.data,
               u.fio,
               rh.id head_id,
               rh.num,
               rh.fio_otv,
               n.net_name,
               ur_tz_name,
               tz_address,
               rb.kodtp,
               rb.vv,
               rb.id rb_id,
               rb.day_TIME_MR plan_minutes,
               CASE WHEN rb.day_TIME_MR > 0 THEN 1 ELSE 0 END plan_mr
          FROM routes_body1 rb,
               routes_head rh,
               routes_head_agents rha,
               routes_tp rt,
               cpp cpp1,
               svms_oblast s,
               ms_nets n,
               (SELECT DISTINCT data, dm FROM calendar) c,
               user_list u,
               merch_report_cal_aa_h h
         WHERE     c.data BETWEEN h.dts AND h.dte
               AND h.id = :activity
               AND rh.data = TRUNC (c.data, 'mm')
               AND u.tn = rh.tn
               AND rb.day_num = c.dm
               AND rh.id = rb.head_id
               AND rh.id = rha.head_id
               AND rha.ag_id = rb.ag_id
               AND rh.id = rt.head_id
               AND rb.kodtp = rt.kodtp
               AND rh.tn = s.tn
               AND (   rh.tn IN (SELECT slave
                                   FROM full
                                  WHERE master = :tn UNION
                        SELECT chief
                          FROM spr_users_ms
                         WHERE     login = :login
                               AND (SELECT is_smr
                                      FROM user_list
                                     WHERE login = :login) = 1)
                    OR (SELECT is_admin
                          FROM user_list
                         WHERE tn = :tn) = 1
                    OR (SELECT is_ma
                          FROM user_list
                         WHERE tn = :tn) = 1)
               AND rb.vv = rha.vv
               AND rha.vv = rt.vv
               AND cpp1.tz_oblast = s.oblast
               AND cpp1.kodtp = rb.kodtp
               AND cpp1.kodtp = rt.kodtp
               AND n.id_net = cpp1.id_net
               AND rha.ag_id = :ag_id
               AND (rb.DAY_enabled_MR = 1)) plan,
       (SELECT mr.dt,
               mr.rb_id,
               MR_FAKT fakt_minutes,
               CASE WHEN MR_FAKT > 0 THEN 1 END fakt_mr
          FROM merch_report mr,
               routes_body1 rb,
               routes_head rh,
               routes_head_agents rha,
               routes_tp rt,
               cpp cpp1,
               svms_oblast s,
               ms_nets n,
               (SELECT DISTINCT data, dm FROM calendar) c,
               merch_report_ok mro,
               merch_report_cal_aa_h h
         WHERE     c.data BETWEEN h.dts AND h.dte
               AND h.id = :activity
               AND rh.data = TRUNC (c.data, 'mm')
               AND mr.dt = c.data
               AND rb.day_num = c.dm
               AND rb.id = mr.rb_id
               AND rh.id = rb.head_id
               AND rh.id = rha.head_id
               AND rha.ag_id = rb.ag_id
               AND rh.id = rt.head_id
               AND rb.kodtp = rt.kodtp
               AND rh.tn = s.tn
               AND rb.vv = rha.vv
               AND rha.vv = rt.vv
               AND cpp1.tz_oblast = s.oblast
               AND cpp1.kodtp = rb.kodtp
               AND cpp1.kodtp = rt.kodtp
               AND n.id_net = cpp1.id_net
               AND rha.ag_id = :ag_id
               AND (  NVL (
                         (SELECT id
                            FROM merch_report_vv
                           WHERE     head_id = rh.id
                                 AND ag_id = rha.ag_id
                                 AND kod_tp = cpp1.kodtp
                                 AND dt = mr.dt),
                         0)
                    + rb.vv <> 1)
               AND (rb.DAY_enabled_MR = 1)
               AND mro.dt = mr.dt
               AND mro.head_id = rh.id) fakt,
       MERCH_REPORT_CAL_REMINDERS r,
       MERCH_REPORT_CAL_AA_H aa_h,
       merch_report_aa_report aa
 WHERE     plan.data = fakt.dt(+)
       AND plan.rb_id = fakt.rb_id(+)
       AND plan.data = r.data
       AND plan.head_id = r.head_id
       AND :ag_id = r.ag_id
       AND plan.kodtp = r.kodtp
       AND r.aa_id = aa_h.id
       AND :ag_id = aa.ag_id(+)
       AND plan.kodtp = aa.kodtp(+)
       AND r.aa_id = :activity
       AND :activity = aa.aa_id(+)
       AND aa.photo IS NOT NULL";
    $sql=stritr($sql,$p);
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    if ($r){
        //ini_set('display_errors', 'On');
        //print_r($r);
        $zip = new ZipArchive();
        $archive = 'files/aa'.$_REQUEST["activity"].'.zip';
        unlink($archive);
        $zip->open($archive, ZIPARCHIVE::CREATE);
        foreach ($r as $k=>$v) {
            //echo $k.' '.$v['photo'];
            $a = explode("\n", $v['photo']);
            //print_r($a);
            foreach ($a as $k1=>$v1) {
            //echo $k1.' '.$v1;
                $zip->addFile('files/'.$v1,translit($v['tz_address']).'_'.$v1);
            }
        }
        $zip->close();
        $smarty->assign('archive', $archive);
    }
} else if (isset($_REQUEST["getAgents"])){
    $smarty->assign('x', $db->getAll("select id, name from routes_agents order by name", null, null, null, MDB2_FETCHMODE_ASSOC));
} else if (isset($_REQUEST["getActivities"])){
    $p = array(
        ":sd"=>"'".$_REQUEST["sd"]."'",
        ":ed"=>"'".$_REQUEST["ed"]."'",
        ":ag_id"=>$_REQUEST["agent"]
    );
    $sql="
  SELECT DISTINCT h.id,
                  n.net_name,
                  TO_CHAR (h.dts, 'dd.mm.yyyy') dts_s,
                  TO_CHAR (h.dte, 'dd.mm.yyyy') dte_s,
                  h.dts,
                  h.dte
    FROM merch_report_cal_aa_h h, ms_nets n, calendar c
   WHERE     c.data BETWEEN h.dts AND h.dte
         AND c.data BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                        AND TO_DATE ( :ed, 'dd.mm.yyyy')
         AND n.id_net = h.id_net
         AND h.ag_id = :ag_id
ORDER BY n.net_name,
         h.dts,
         h.dte,
         h.id";
    $sql=stritr($sql,$p);
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
}
$smarty->display('merch_report_aa_reports.html');