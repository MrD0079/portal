/* Formatted on 05.04.2013 16:35:57 (QP5 v5.163.1008.3004) */
  SELECT COUNT (*) c, full
    FROM (SELECT b.tn,
                 (SELECT full
                    FROM full
                   WHERE master = :tn AND slave = b.tn)
                    full
            FROM dc_order_head h,
                 dc_order_body b,
                 user_list u,
                 tr_loc l,
                 user_list u1
           WHERE     h.dt_start >= TRUNC (SYSDATE)
                 AND u.tn = h.tn
                 AND h.loc = l.id
                 AND h.id = b.head
                 AND b.tn = u1.tn
                 AND u1.tn IN (SELECT slave
                                 FROM full
                                WHERE master = :tn)
                 AND b.manual >= 0)
GROUP BY full