/* Formatted on 09.12.2013 16:17:54 (QP5 v5.227.12220.39724) */
SELECT NVL (u1.tn, u2.tn) tn, NVL (u1.fio, u2.fio) fio
  FROM user_list u1,
       user_list u,
       parents p,
       user_list u2
 WHERE     u1.is_rm(+) = 1
       AND u1.region_name(+) = u.region_name
       AND u1.datauvol(+) IS NULL
       AND u.tn = :tn
       AND u.dpt_id = u1.dpt_id(+)
       AND u.tn = p.tn(+)
       AND u2.tn(+) = p.parent