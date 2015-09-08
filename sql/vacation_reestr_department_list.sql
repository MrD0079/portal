/* Formatted on 23/12/2013 14:52:15 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT u.department_name
    FROM vacation v,
         user_list u,
         departments d,
         (SELECT slave
            FROM full
           WHERE master = :tn) f
   WHERE     v.tn = u.tn
         AND d.dpt_id = u.dpt_id
         AND u.tn > 0
         AND TRIM (u.department_name) IS NOT NULL
         AND (   f.slave = v.tn
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
ORDER BY u.department_name