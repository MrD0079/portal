/* Formatted on 16.09.2013 14:14:12 (QP5 v5.227.12220.39724) */
  SELECT q_id, q_name, tr.ok
    FROM (SELECT q.id_num q_id,
                 b.h_eta,
                 b.head,
                 q.name q_name,
                 q.num
            FROM tr_pt_order_head h, tr_pt_order_body b, TR_TEST_QA q
           WHERE     h.id = b.head
                 AND h.id = :id
                 AND b.h_eta = :h_eta
                 AND h.tr = q.tr
                 AND q.TYPE = 5) q1,
         tr_pt_order_test_res tr
   WHERE     q1.q_id = tr.q(+)
         AND q1.h_eta = tr.h_eta(+)
         AND q1.head = tr.head(+)
         AND NVL (tr.ok, 0) <> 1
ORDER BY q1.num