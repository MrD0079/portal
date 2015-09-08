/* Formatted on 14.01.2014 12:29:12 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT u.department_name
    FROM tmc t, user_list u, departments d
   WHERE     t.tn = u.tn
         AND d.dpt_id = u.dpt_id
         AND u.tn > 0
         AND TRIM (u.department_name) IS NOT NULL
         AND (   t.tn IN (SELECT slave
                            FROM full
                           WHERE master = :tn)
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_super, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_traid_kk, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_it, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
ORDER BY u.department_name