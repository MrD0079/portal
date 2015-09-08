/* Formatted on 09/04/2015 13:28:35 (QP5 v5.227.12220.39724) */
  SELECT COUNT (*) c, period_ended, full
    FROM (SELECT CASE WHEN p.data_end <= SYSDATE THEN 1 ELSE 0 END period_ended,
                 CASE
                    WHEN (    (pp.ok_employee = 1 OR inst_tn IS NULL)
                          AND (pp.ok_teacher = 1 OR chief_tn IS NULL)
                          AND (pp.ok_chief = 1 OR dir_tn IS NULL))
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
           WHERE     (   :tn IN (prob_tn, inst_tn, chief_tn, dir_tn)
                      OR (SELECT is_super
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND p.prob_tn = pp.tn
                 AND p.prob_tn = u.tn
                 AND u.dpt_id = :dpt_id
                 AND NVL (u.is_top, 0) <> 1)
   WHERE ad_completed = 0
GROUP BY period_ended, full