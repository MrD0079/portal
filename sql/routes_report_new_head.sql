/* Formatted on 14.03.2014 15:11:00 (QP5 v5.227.12220.39724) */
SELECT TO_CHAR (h.data, 'dd.mm.yyyy') data,
       h.fio_otv,
       h.num,
       u.fio,
       c.mt,
       c.y
  FROM routes_head h, user_list u, calendar c
 WHERE h.id = :route AND u.tn = h.tn AND c.data = h.data