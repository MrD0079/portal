/* Formatted on 17.07.2013 14:45:21 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT u.department_name
    FROM bud_ru_zay,
         user_list u,
         departments d/*,
         (SELECT slave
            FROM full
           WHERE master = :tn) f*/
   WHERE     bud_ru_zay.tn = u.tn
         AND d.dpt_id = u.dpt_id
         AND u.tn > 0
         AND TRIM (u.department_name) IS NOT NULL
/*         AND (   f.slave = bud_ru_zay.tn
              OR (SELECT NVL (is_do, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)*/
and d.dpt_id=:dpt_id
ORDER BY u.department_name