/* Formatted on 23/06/2015 13:24:12 (QP5 v5.227.12220.39724) */
  SELECT u.tn,
         u.fio,
         u.pos_name,
         u.dpt_name,
         d.sort,
         a.*
    FROM user_list u, departments d, assist a
   WHERE     d.dpt_id = u.dpt_id
         AND u.datauvol IS NULL
         AND u.is_spd = 1
         AND u.tn <> :tn
         AND u.tn = a.parent(+)
         AND :tn = a.child(+)
         AND u.dpt_id = a.dpt_id(+)
         AND 1 = a.accept(+)
         AND a.child IS NULL
ORDER BY d.sort, u.fio