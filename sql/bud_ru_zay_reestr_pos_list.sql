/* Formatted on 17.07.2013 14:43:47 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT u.pos_id, u.pos_name
    FROM bud_ru_zay,
         user_list u,
         departments d/*,
         (SELECT slave
            FROM full
           WHERE master = :tn) f*/
   WHERE     bud_ru_zay.tn = u.tn
         AND d.dpt_id = u.dpt_id
         AND u.tn > 0
         AND u.pos_name IS NOT NULL
/*         AND (   f.slave = bud_ru_zay.tn
              OR (SELECT NVL (is_do, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)*/
ORDER BY u.pos_name