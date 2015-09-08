/* Formatted on 09.07.2013 15:25:59 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT s.tn,
                  u.fio,
                  u.pos_name,
                  u.dpt_name,
                  d.sort
    FROM bud_ru_zay s, user_list u, departments d
   WHERE     s.tn = u.tn
         AND d.dpt_id = u.dpt_id
         AND u.tn > 0
ORDER BY d.sort, u.fio