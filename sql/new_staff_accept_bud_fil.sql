/* Formatted on 07.02.2014 15:49:07 (QP5 v5.227.12220.39724) */
  SELECT DECODE (c.id, NULL, NULL, 1) enabled, u.name, u.id
    FROM new_staff_bud_fil c, bud_fil u, new_staff n
   WHERE     c.parent(+) = :id
         AND c.fil(+) = u.id
         AND n.id = :id
         AND n.dpt_id = u.dpt_id
ORDER BY u.name