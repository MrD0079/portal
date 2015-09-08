/* Formatted on 16.09.2013 14:15:20 (QP5 v5.227.12220.39724) */
  SELECT th.id test_id,
         DECODE ( (SELECT NVL (COUNT (*), 0)
                     FROM TR_TEST_QA qa
                    WHERE qa.TYPE = 5 AND qa.tr = h.tr),
                 0, 0,
                 ROUND (  th.ball
                        / (SELECT NVL (COUNT (*), 0)
                             FROM TR_TEST_QA qa
                            WHERE qa.TYPE = 5 AND qa.tr = h.tr)
                        * 100,
                        2))
            test_perc,
         th.ball test_ball,
         TO_CHAR (th.lu, 'dd/mm/yyyy hh24:mi:ss') test_lu
    FROM tr_pt_order_head h, tr_pt_order_body b, tr_pt_order_test_history th
   WHERE     h.id = :id
         AND h.id = b.head
         AND th.h_eta(+) = b.h_eta
         AND TH.HEAD = b.head
         AND b.h_eta = :h_eta
ORDER BY th.lu