/* Formatted on 13.06.2014 12:55:34 (QP5 v5.227.12220.39724) */
  SELECT z.emp_tn,
         z.emp_fio,
         z.proff,
         SUM (NVL (fn_get_score_pos (z.emp_tn, z.exp_tn, :event), 0)) score,
         SUM (NVL (fn_get_score_tn (z.emp_tn, 'self_score', :event), 0))
            self_score,
         SUM (NVL (fn_get_score_tn (z.emp_tn, 'chief_score', :event), 0))
            chief_score,
         SUM (NVL (fn_get_score_tn (z.emp_tn, 'exp_avg_score', :event), 0))
            exp_avg_score,
         SUM (NVL (fn_get_score_tn (z.emp_tn, 'self_score_t', :event), 0))
            self_score_t,
         SUM (NVL (fn_get_score_tn (z.emp_tn, 'chief_score_t', :event), 0))
            chief_score_t,
         SUM (NVL (fn_get_score_tn (z.emp_tn, 'exp_avg_score_t', :event), 0))
            exp_avg_score_t,
         SUM (NVL (fn_get_score_tn (z.emp_tn, 'score_t', :event), 0)) score_t,
         (SELECT SUM (s.score)
            FROM ocenka_score s
           WHERE s.exp_tn = z.emp_tn AND s.tn IS NULL AND s.event = :event)
            test_result,
         z.FULL,
         z.ocenka,
         (SELECT dev_sol
            FROM ocenka_exp_comment
           WHERE tn = z.emp_tn AND tn = exp_tn AND event = :event)
            dc
    FROM (  SELECT DISTINCT e.FULL,
                            e.master exp_tn,
                            e.slave emp_tn,
                            u.fio emp_fio,
                            u.pos_name proff,
                            u1.ocenka
              FROM full e,
                   ocenka_score s,
                   user_list u,
                   user_list u1
             WHERE     u.datauvol IS NULL
                   AND e.master = :exp_tn
                   AND s.exp_tn(+) = e.master
                   AND s.event(+) = :event
                   AND s.tn(+) = e.slave
                   AND u.tn = e.slave
                   AND u.dpt_id = :dpt_id
                   AND u1.tn = e.master
          GROUP BY e.FULL,
                   e.master,
                   e.slave,
                   s.criteria,
                   u.fio,
                   u.pos_name,
                   u1.ocenka) z
GROUP BY z.emp_tn,
         z.proff,
         z.emp_fio,
         z.FULL,
         z.ocenka
ORDER BY z.full, z.emp_fio