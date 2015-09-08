/* Formatted on 12.12.2014 0:23:00 (QP5 v5.227.12220.39724) */
SELECT q.id, q.name, r.ok
  FROM p_plan p, prob_test q, prob_test_res r
 WHERE     p.tn = :tn
       AND p.test_id = q.parent
       AND r.tn(+) = :tn
       AND r.test_id(+) = q.parent
       AND r.q(+) = q.id
       AND NVL (r.ok, 0) <> 1