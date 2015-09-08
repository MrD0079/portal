/* Formatted on 23.04.2013 10:33:46 (QP5 v5.163.1008.3004) */
SELECT u.fio,
       u.tn,
       TO_CHAR (h.dt_start, 'dd.mm.yyyy') dt_start,
       l.name loc_name,
       tr.name
  FROM tr_order_head h,
       tr_order_body b,
       user_list u,
       tr_loc l,
       tr
 WHERE     h.dt_start >= TRUNC (SYSDATE)
       AND h.tr = tr.id
       AND h.loc = l.id
       AND h.id = b.head
       AND b.manual >= 0
       AND h.ok_final = 1
       AND u.tn = b.tn
       AND b.tn IN (SELECT slave
                      FROM full
                     WHERE master = :tn AND full <> 0)