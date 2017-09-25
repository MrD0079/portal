/* Formatted on 25.09.2017 09:23:58 (QP5 v5.252.13127.32867) */
  SELECT COUNT (*) c, period_ended, full
    FROM (SELECT CASE WHEN p.data_end <= SYSDATE THEN 1 ELSE 0 END period_ended,
                 CASE
                    WHEN (    (pp.ok_employee = 1 OR p.inst_tn IS NULL)
                          AND (pp.ok_teacher = 1 OR p.chief_tn IS NULL)
                          AND (pp.ok_chief = 1 OR p.dir_tn IS NULL))
                    THEN
                       1
                    ELSE
                       0
                 END
                    ad_completed,
                 NVL ( (SELECT full
                          FROM full
                         WHERE master = :tn AND slave = p.prob_tn),
                      0)
                    full,
                 :tn,
                 p.prob_tn
            FROM p_prob_inst p, p_plan pp, user_list u
           WHERE     (   :tn IN (p.prob_tn,
                                 p.inst_tn,
                                 p.chief_tn,
                                 p.dir_tn)
                      OR (SELECT is_super
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND p.prob_tn = pp.tn
                 AND p.prob_tn = u.tn
                 AND u.dpt_id = :dpt_id
                 AND NVL (u.is_top, 0) <> 1)
   WHERE ad_completed = 0
GROUP BY period_ended, full