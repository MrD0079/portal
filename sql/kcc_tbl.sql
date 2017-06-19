/* Formatted on 18/09/2015 11:38:58 (QP5 v5.227.12220.39724) */
  SELECT u.tn,
         u.fio,
         k.*,
         (SELECT   SUM (
                      DECODE (
                         h.completed,
                         1, (SELECT SUM (test_ball)
                               FROM tr_order_body
                              WHERE     head = h.id
                                    AND manual >= 0
                                    AND completed = 1
                                    AND test = 2),
                         0))
                 / SUM (
                        (SELECT NVL (COUNT (*), 0)
                           FROM tr_test_qa qa
                          WHERE qa.TYPE = 5 AND qa.tr = tr.id)
                      * (SELECT NVL (COUNT (*), 0)
                           FROM tr_order_body
                          WHERE     head = h.id
                                AND manual >= 0
                                AND completed = 1
                                AND test = 2))
                 * 100
                    perc
            FROM tr_order_head h, tr, tr_loc l
           WHERE     TRUNC (h.dt_start, 'mm') = TO_DATE (:sd, 'dd/mm/yyyy')
                 AND tr.id = h.tr
                 AND h.loc = l.id
                 AND h.tn = u.tn
                 AND h.completed = 1
                 AND h.ok_primary = 1)
            perc,
         (SELECT COUNT (*)
            FROM spr_users_eta h,
                 spr_users s,
                 (SELECT DISTINCT ur.tab_number tab_number, ur.h_eta h_eta
                    FROM routes ur
                   WHERE ur.tab_number > 0 AND ur.dpt_id = :dpt_id) r,
                 user_list uts,
                 emp_exp t1,
                 user_list t2
           WHERE     h.login = S.LOGIN
                 AND h.dpt_id = :dpt_id
                 AND h.h_eta = r.h_eta
                 AND uts.tab_num = r.tab_number
                 AND uts.dpt_id = :dpt_id
                 AND t1.emp_tn = uts.tn
                 AND t1.exp_tn = t2.tn
                 AND t2.is_coach = 1
                 AND t2.dpt_id = :dpt_id
                 AND h.reserv = 1
                 AND t2.tn = u.tn)
            res_ts,
         (SELECT COUNT (*)
            FROM full f, user_list uf
           WHERE     f.master = u.tn
                 AND f.full = 0
                 AND f.slave = uf.tn
                 AND uf.res = 1
                 AND uf.res_pos_id IN (SELECT pos_id
                                         FROM pos_kk
                                        WHERE is_tm = 1))
            res_tm,
         (SELECT COUNT (*)
            FROM full f, user_list uf
           WHERE     f.master = u.tn
                 AND f.full = 0
                 AND f.slave = uf.tn
                 AND uf.res = 1
                 AND uf.res_pos_id IN (SELECT pos_id
                                         FROM pos_kk
                                        WHERE is_rm = 1))
            res_rm,
         (SELECT COUNT (*)
            FROM full f, user_list uf
           WHERE     f.master = u.tn
                 AND f.full = 0
                 AND f.slave = uf.tn
                 AND uf.res = 1
                 AND uf.res_pos_id IN (SELECT pos_id
                                         FROM pos_kk
                                        WHERE is_nm = 1))
            res_nm,
         NVL (prob_prosroch.prob_ts, 0) prob_ts,
         NVL (prob_prosroch.prob_tm, 0) prob_tm,
         NVL (prob_prosroch.prob_rm, 0) prob_rm,
         NVL (prob_prosroch.prob_nm, 0) prob_nm,
         prob_test_perc.ts_perc ts_perc,
         prob_test_perc.tm_perc tm_perc,
         prob_test_perc.rm_perc rm_perc,
         prob_test_perc.nm_perc nm_perc
    FROM user_list u,
         kcc k,
         (  SELECT coach,
                   SUM (is_ts) prob_ts,
                   SUM (is_tm) prob_tm,
                   SUM (is_rm) prob_rm,
                   SUM (is_nm) prob_nm
              FROM (SELECT p.prob_tn,
                           p.chief_tn coach,
                           p.data_end data_end_plan,
                           TRUNC (
                              GREATEST (NVL (pp.stamp_employee, SYSDATE),
                                        NVL (pp.stamp_teacher, SYSDATE),
                                        NVL (pp.stamp_chief, SYSDATE)))
                              data_end_fakt,
                           TRUNC (
                                p.data_end
                              - TRUNC (
                                   GREATEST (NVL (pp.stamp_employee, SYSDATE),
                                             NVL (pp.stamp_teacher, SYSDATE),
                                             NVL (pp.stamp_chief, SYSDATE))))
                              delta,
                           UP.is_ts,
                           UP.is_tm,
                           UP.is_rm,
                           UP.is_nm
                      FROM p_prob_inst p, p_plan pp, user_list UP
                     WHERE     p.prob_tn = UP.tn
                           AND p.prob_tn = pp.tn
                           AND TRUNC (
                                  GREATEST (NVL (pp.stamp_employee, SYSDATE),
                                            NVL (pp.stamp_teacher, SYSDATE),
                                            NVL (pp.stamp_chief, SYSDATE))) >
                                  p.data_end + 7
                           AND p.chief_tn IS NOT NULL
                           AND TRUNC (p.data_end, 'mm') =
                                  TO_DATE (:sd, 'dd/mm/yyyy'))
          GROUP BY coach) prob_prosroch,
         (  SELECT coach,
                   SUM (is_ts) prob_ts,
                   SUM (is_tm) prob_tm,
                   SUM (is_rm) prob_rm,
                   SUM (is_nm) prob_nm,
                   SUM (CASE WHEN is_ts = 1 THEN test_ball END) ts_test_ball,
                   SUM (CASE WHEN is_tm = 1 THEN test_ball END) tm_test_ball,
                   SUM (CASE WHEN is_rm = 1 THEN test_ball END) rm_test_ball,
                   SUM (CASE WHEN is_nm = 1 THEN test_ball END) nm_test_ball,
                   SUM (CASE WHEN is_ts = 1 THEN max_ball END) ts_max_ball,
                   SUM (CASE WHEN is_tm = 1 THEN max_ball END) tm_max_ball,
                   SUM (CASE WHEN is_rm = 1 THEN max_ball END) rm_max_ball,
                   SUM (CASE WHEN is_nm = 1 THEN max_ball END) nm_max_ball,
                   DECODE (
                      SUM (CASE WHEN is_ts = 1 THEN max_ball END),
                      0, 0,
                        SUM (CASE WHEN is_ts = 1 THEN test_ball END)
                      / SUM (CASE WHEN is_ts = 1 THEN max_ball END)
                      * 100)
                      ts_perc,
                   DECODE (
                      SUM (CASE WHEN is_tm = 1 THEN max_ball END),
                      0, 0,
                        SUM (CASE WHEN is_tm = 1 THEN test_ball END)
                      / SUM (CASE WHEN is_tm = 1 THEN max_ball END)
                      * 100)
                      tm_perc,
                   DECODE (
                      SUM (CASE WHEN is_rm = 1 THEN max_ball END),
                      0, 0,
                        SUM (CASE WHEN is_rm = 1 THEN test_ball END)
                      / SUM (CASE WHEN is_rm = 1 THEN max_ball END)
                      * 100)
                      rm_perc,
                   DECODE (
                      SUM (CASE WHEN is_nm = 1 THEN max_ball END),
                      0, 0,
                        SUM (CASE WHEN is_nm = 1 THEN test_ball END)
                      / SUM (CASE WHEN is_nm = 1 THEN max_ball END)
                      * 100)
                      nm_perc,
                   NULL
              FROM (SELECT p.prob_tn,
                           p.chief_tn coach,
                           p.data_end data_end_plan,
                           UP.is_ts,
                           UP.is_tm,
                           UP.is_rm,
                           UP.is_nm,
                           pp.test_ball,
                           NVL ( (SELECT COUNT (*)
                                    FROM prob_test
                                   WHERE parent = pp.test_id),
                                0)
                              max_ball,
                           DECODE (NVL ( (SELECT COUNT (*)
                                            FROM prob_test
                                           WHERE parent = pp.test_id),
                                        0),
                                   0, 0,
                                     pp.test_ball
                                   / (SELECT COUNT (*)
                                        FROM prob_test
                                       WHERE parent = pp.test_id)
                                   * 100)
                              perc
                      FROM p_prob_inst p, p_plan pp, user_list UP
                     WHERE     p.prob_tn = UP.tn
                           AND p.prob_tn = pp.tn
                           AND p.chief_tn IS NOT NULL
                           AND pp.test = 2
                           AND TRUNC (p.data_end, 'mm') =
                                  TO_DATE (:sd, 'dd/mm/yyyy'))
          GROUP BY coach) prob_test_perc
   WHERE     u.is_coach = 1
         AND u.tn = k.coach(+)
         AND k.dt = TO_DATE (:sd, 'dd.mm.yyyy')
         AND u.dpt_id = :dpt_id
   and u.is_spd=1
      AND u.tn = prob_prosroch.coach(+)
         AND u.tn = prob_test_perc.coach(+)
         AND (   u.tn IN (SELECT slave
                            FROM full
                           WHERE master = :tn)
              OR (SELECT NVL (is_acceptor, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_ndp, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_dpu, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
ORDER BY u.fio