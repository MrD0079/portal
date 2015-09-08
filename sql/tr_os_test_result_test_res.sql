/* Formatted on 28.01.2013 13:53:16 (QP5 v5.163.1008.3004) */
  SELECT q_id, q_name, tr.ok
    FROM (SELECT q.id_num q_id,
                 b.tn,
                 b.head,
                 q.name q_name,
                 q.num
            FROM tr_order_head h, tr_order_body b, tr_test_qa q
           WHERE h.id = b.head AND h.id = :id AND b.tn = :tn AND h.tr = q.tr AND q.TYPE = 5) q1,
         tr_order_test_res tr
   WHERE q1.q_id = tr.q(+) AND q1.tn = tr.tn(+) AND q1.head = tr.head(+) AND NVL (tr.ok, 0) <> 1
ORDER BY q1.num