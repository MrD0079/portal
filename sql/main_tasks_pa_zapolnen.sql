  SELECT full, COUNT (*) e
    FROM full, user_list u
   WHERE     u.tn = full.slave
         AND NVL (u.is_top, 0) <> 1
         AND u.datauvol IS NULL
         AND full.dpt_id = :dpt_id
         AND full.master = :tn
         AND (   EXISTS
                    (SELECT tn
                       FROM p_activ_plan_daily
                      WHERE tn = full.slave AND month = f1)
              OR EXISTS
                    (SELECT tn
                       FROM p_activ_plan_weekly w
                      WHERE w.month = f1 AND w.tn = full.slave))
GROUP BY full