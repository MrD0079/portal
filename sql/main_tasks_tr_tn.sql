/* Formatted on 15.01.2013 9:33:07 (QP5 v5.163.1008.3004) */
  SELECT COUNT (DISTINCT tn) tn, full
    FROM (SELECT b.tn,
                 (SELECT full
                    FROM full
                   WHERE master = :tn AND slave = b.tn)
                    full
            FROM tr_order_head h, tr_order_body b
           WHERE     h.dt_start >= TRUNC (SYSDATE)
                 AND h.id = b.head
                 AND b.manual >= 0
                 AND h.ok_final = 1
                 AND b.tn IN (SELECT slave
                                FROM full
                               WHERE master = :tn))
GROUP BY full