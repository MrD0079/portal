/* Formatted on 01.03.2013 16:04:32 (QP5 v5.163.1008.3004) */
/*  SELECT TO_CHAR (b.lu, 'dd.mm.yyyy') dt, ball
    FROM tr_order_test_history b
   WHERE b.tn = :tn AND b.head = :head
ORDER BY b.id*/

/* Formatted on 22.03.2013 10:03:33 (QP5 v5.163.1008.3004) */
  SELECT TO_CHAR (th.lu, 'dd.mm.yyyy') dt,
         th.ball,
         DECODE ( (SELECT NVL (COUNT (*), 0)
                     FROM tr_test_qa qa
                    WHERE qa.TYPE = 5 AND qa.tr = h.tr),
                 0, 0,
                 ROUND (  th.ball
                        / (SELECT NVL (COUNT (*), 0)
                             FROM tr_test_qa qa
                            WHERE qa.TYPE = 5 AND qa.tr = h.tr)
                        * 100,
                        2))
            test_perc,
         th.ball test_ball,
         TO_CHAR (th.lu, 'dd/mm/yyyy hh24:mi:ss') test_lu
    FROM tr_order_head h, tr_order_body b, tr_order_test_history th
   WHERE h.id = :head AND h.id = b.head AND th.tn = b.tn AND TH.HEAD = b.head AND th.tn = :tn
ORDER BY th.lu