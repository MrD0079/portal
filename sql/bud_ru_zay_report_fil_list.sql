/* Formatted on 31.10.2013 10:30:37 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT b.id, b.name
    FROM bud_ru_zay,
         user_list u,
         bud_fil b/*,
         (SELECT slave
            FROM full
           WHERE master = :tn) f*/
   WHERE     bud_ru_zay.tn = u.tn
         AND bud_ru_zay.fil = b.id
         AND u.tn > 0
         AND TRIM (u.department_name) IS NOT NULL
/*         AND (   f.slave = bud_ru_zay.tn
              OR (SELECT NVL (is_do, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)*/
and b.dpt_id=:dpt_id
ORDER BY b.name