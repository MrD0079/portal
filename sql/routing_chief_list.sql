/* Formatted on 11.04.2013 10:08:21 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT w.slave emp_svid,
                  u.fio emp_name,
                  u.pos_name emp_pos,
                  u.datauvol,
                  u.is_ts
    FROM full w, user_list u
   WHERE     u.dpt_id = :dpt_id
         AND u.tn = w.slave
         AND (   w.master = :tn
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_super, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_kpr, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND (NVL (u.is_ts, 0) <> 1 AND NVL (u.is_mkk, 0) <> 1)
         AND u.datauvol IS NULL
ORDER BY emp_name