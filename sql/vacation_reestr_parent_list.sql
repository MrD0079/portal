/* Formatted on 23/12/2013 15:17:33 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT u.tn,
                  u.fio,
                  u.pos_name,
                  u.dpt_name,
                  d.sort
    FROM vacation v,
         parents p,
         user_list u,
         (SELECT slave
            FROM full
           WHERE master = :tn) f,
         departments d
   WHERE     v.tn = p.tn
         AND u.tn = p.parent
         AND (   f.slave = u.tn
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND u.datauvol IS NULL
         AND d.dpt_id = u.dpt_id
         AND u.tn > 0
ORDER BY d.sort, u.fio