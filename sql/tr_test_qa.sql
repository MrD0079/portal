/* Formatted on 16.01.2013 14:42:52 (QP5 v5.163.1008.3004) */
  SELECT t5.id_num q_id,
         t5.name q_name,
         t5.num q_num,
         t6.id_num a_id,
         t6.name a_name,
         t6.num a_num,
         t6.parent a_parent,
         t6.weight a_weight
    FROM tr_test_qa t5, tr_test_qa t6
   WHERE t5.id_num = t6.parent(+) AND t5.TYPE = 5 AND t5.tr = :tr AND t6.tr(+) = :tr
ORDER BY t5.num, t6.num