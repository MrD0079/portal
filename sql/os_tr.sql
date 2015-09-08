/* Formatted on 09.07.2014 10:10:26 (QP5 v5.227.12220.39724) */
  SELECT h.id,
         tr.name,
         TO_CHAR (h.dt_start, 'dd.mm.yyyy') dt_start,
         b.os,
         u.fio tr_fio
    FROM tr,
         tr_order_head h,
         tr_order_body b,
         user_list u
   WHERE     b.tn = :tn
         AND b.manual >= 0
         AND h.id = b.head
         AND tr.id = h.tr
         AND h.completed = 1
         AND b.completed = 1
         AND dt_start >= TRUNC (SYSDATE) - 180
         AND u.tn = h.tn
ORDER BY tr.name, h.dt_start