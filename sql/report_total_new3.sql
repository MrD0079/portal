/* Formatted on 06/08/2015 16:01:24 (QP5 v5.227.12220.39724) */
SELECT COUNT (*) c,
       SUM (day_TIME_MR) day_TIME_MR,
       /*SUM (day_TIME_F) day_TIME_F,*/
       SUM (MR_DELTA) MR_DELTA,
       /*SUM (f_DELTA) f_DELTA,*/
       SUM (MR_FAKT) MR_FAKT                                             /*,*/
  /*SUM (F_FAKT) F_FAKT,*/
  /*SUM (RAS) RAS*/
  FROM (SELECT DISTINCT
               mr.id,
               TO_CHAR (mr.DT, 'dd.mm.yyyy') dt,
               mr.dt,
               rh.fio_otv,
               rh.num,
               rh.id head_id,
               cpp1.tz_oblast,
               n.net_name,
               n.id_net,
               ur_tz_name,
               tz_address,
               cpp1.kodtp,
               ra.name ag_name,
               ra.id ag_id,
               (SELECT COUNT (*)
                  FROM merch_spec_head msh
                 WHERE     msh.kod_tp = cpp1.kodtp
                       AND msh.ag_id = ra.id
                       AND msh.id_net = n.id_net)
                  spec,
               (SELECT id
                  FROM merch_spec_head msh
                 WHERE     msh.kod_tp = cpp1.kodtp
                       AND msh.ag_id = ra.id
                       AND msh.id_net = n.id_net
                       AND msh.sd =
                              (SELECT MAX (sd)
                                 FROM merch_spec_head
                                WHERE     id_net = n.id_net
                                      AND kod_tp = cpp1.kodtp
                                      AND ag_id = ra.id
                                      AND sd <= TO_DATE (:ed, 'dd/mm/yyyy')))
                  spec_id,
               c.dm,
               rb.DAY_enabled_MR,
               /*rb.DAY_enabled_F,*/
               rb.DAY_TIME_MR,
               /*rb.DAY_TIME_F,*/
               - (NVL (rb.DAY_TIME_MR, 0) - MR_FAKT) MR_DELTA,
               /*- (NVL (rb.DAY_TIME_F, 0) - f_FAKT) f_DELTA,*/
               MR_FAKT mr_fakt,
               MR_TEXT,
               /*F_FAKT f_fakt,
               F_TEXT,
               RAS,
               RAS_TEXT,*/
               rb.vv,
               (SELECT svms_ok
                  FROM merch_report_ok
                 WHERE dt = mr.dt AND head_id = rh.id)
                  svms_ok,
               (SELECT TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss')
                  FROM merch_report_ok
                 WHERE dt = mr.dt AND head_id = rh.id)
                  svms_ok_date
          FROM merch_report mr,
               routes_body1 rb,
               routes_head rh,
               routes_head_agents rha,
               routes_agents ra,
               routes_tp rt,
               cpp cpp1,
               svms_oblast s,
               ms_nets n,
               (SELECT DISTINCT data, dm FROM calendar) c
         WHERE     mr.dt BETWEEN TO_DATE (:sd, 'dd/mm/yyyy')
                             AND TO_DATE (:ed, 'dd/mm/yyyy')
               AND mr.dt = c.data
               AND rb.day_num = c.dm
               AND rb.id = mr.rb_id
               AND rh.id = rb.head_id
               AND rh.id = rha.head_id
               AND ra.id = rha.ag_id
               AND ra.id = rb.ag_id
               AND rh.id = rt.head_id
               AND rb.kodtp = rt.kodtp
               AND rh.tn = s.tn
               AND rb.vv = rha.vv
               AND rha.vv = rt.vv
               AND cpp1.tz_oblast = s.oblast
               AND cpp1.kodtp = rb.kodtp
               AND cpp1.kodtp = rt.kodtp
               AND n.id_net = cpp1.id_net
               AND DECODE (:svms_list, 0, 0, rh.tn) =
                      DECODE (:svms_list, 0, 0, :svms_list)
               AND rha.ag_id IN (:ha)
               AND DECODE (:select_route_numb, 0, 0, rh.id) =
                      DECODE (:select_route_numb, 0, 0, :select_route_numb)
               AND (   rh.tn IN (SELECT emp_tn
                                   FROM who_full
                                  WHERE exp_tn = :tn)
                    OR (SELECT is_admin
                          FROM user_list
                         WHERE tn = :tn) = 1
                    OR (SELECT is_ma
                          FROM user_list
                         WHERE tn = :tn) = 1)
               AND (  NVL (
                         (SELECT id
                            FROM merch_report_vv
                           WHERE     head_id = rh.id
                                 AND ag_id = ra.id
                                 AND kod_tp = cpp1.kodtp
                                 AND dt = mr.dt),
                         0)
                    + rb.vv <> 1)
               AND (rb.DAY_enabled_MR = 1          /*OR rb.DAY_enabled_F = 1*/
                                         ))