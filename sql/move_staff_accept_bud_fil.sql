/* Formatted on 13.02.2014 12:51:45 (QP5 v5.227.12220.39724) */
  SELECT DECODE (c.id, NULL, NULL, 1) enabled, u.name, u.id
    FROM move_staff_bud_fil c, bud_fil u, move_staff n
   WHERE c.parent(+) = :id AND c.fil(+) = u.id AND n.id = :id
ORDER BY u.name