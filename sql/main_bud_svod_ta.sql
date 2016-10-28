/* Formatted on 16/11/2015 16:50:38 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT c.mt || ' ' || c.y period,
                  TO_CHAR (t.dt, 'dd.mm.yyyy') dt_txt,
                  t.dt,
                  u.fio,
                  u.tn
    FROM bud_svod_taf t, user_list u, calendar c
   WHERE     u.tn = t.ok_db_tn
         AND TRUNC (c.data, 'mm') = t.dt
         AND (   (    u.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn AND full = 1)
                  AND t.ok_pr_tn IS NULL)
              OR (    (SELECT is_traid
                         FROM user_list
                        WHERE tn = :tn) = 1
                  AND t.ok_pr_tn IS NOT NULL
                  AND (t.ok_t1_tn IS NULL OR t.ok_t2_tn IS NULL)
                  AND NVL (u.is_kk, 0) <> 1)
              OR (    (SELECT is_traid_kk
                         FROM user_list
                        WHERE tn = :tn) = 1
                  AND t.ok_pr_tn IS NOT NULL
                  AND (t.ok_t1_tn IS NULL OR t.ok_t2_tn IS NULL)
                  AND NVL (u.is_kk, 0) = 1))
ORDER BY t.dt, u.fio