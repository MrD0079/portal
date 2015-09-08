/* Formatted on 12/09/2014 14:46:48 (QP5 v5.227.12220.39724) */
  SELECT q1.id, q1.name, tr.ok
    FROM (SELECT q.id, q.name, q_sort
            FROM ac_test q
           WHERE q.parent = :ac_test_id) q1,
         ac_test_res tr
   WHERE     q1.id = tr.q(+)
         AND :memb_id = tr.memb_id(+)
         AND :ac_id = tr.ac_id(+)
         AND :ac_test_id = tr.test_id(+)
         AND NVL (tr.ok, 0) <> 1
ORDER BY q1.q_sort