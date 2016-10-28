/* Formatted on 06/04/2016 14:45:46 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT u.tn emp_svid,
                  u.fio emp_name,
                  u.pos_name emp_pos,
                  u.datauvol,
                  u.is_ts
    FROM user_list u
   WHERE     u.dpt_id = :dpt_id
         AND (   u.tn IN (SELECT slave
                            FROM full
                           WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_super, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_kpr, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND (NVL (u.is_ts, 0) = 1 OR NVL (u.is_mkk, 0) = 1)
         AND u.datauvol IS NULL
ORDER BY emp_name