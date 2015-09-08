/* Formatted on 24.05.2013 12:02:34 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT w.slave emp_svid,
                  u.fio emp_name,
                  u.pos_name emp_pos,
                  u.datauvol
    FROM full w, user_list u
   WHERE     u.dpt_id = :dpt_id
         AND u.tn = w.slave
         AND (w.master = :tn
              OR (SELECT NVL (is_super, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND (u.is_ts = 1 OR u.is_mkk = 1)
         /*AND u.datauvol IS NULL*/
ORDER BY emp_name