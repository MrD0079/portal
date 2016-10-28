/* Formatted on 13/03/2015 14:18:32 (QP5 v5.227.12220.39724) */
  SELECT SUM (d.summa) summa,
         d.id,
         d.fn,
         u.fio fio_ts
    FROM sc_svodf d, user_list u
   WHERE     d.tn = u.tn
         AND (   :exp_list_without_ts = 0
                      OR u.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_without_ts))
         AND (   :exp_list_only_ts = 0
                      OR u.tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :exp_list_only_ts))
         AND (   u.tn IN (SELECT slave
                            FROM full
                           WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_traid_kk, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND u.dpt_id = :dpt_id
         AND u.dpt_id = d.dpt_id
         AND d.dt = TO_DATE (:dt, 'dd.mm.yyyy')
GROUP BY CUBE (u.fio, d.id, d.fn)
ORDER BY u.fio, d.fn