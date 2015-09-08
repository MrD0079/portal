/* Formatted on 23.01.2013 16:54:02 (QP5 v5.163.1008.3004) */
SELECT DECODE (COUNT (*), 0, 1, 0)
  FROM (SELECT id_num, name, weight
          FROM tr_test_qa
         WHERE parent = :q) q,
       (SELECT id_num, name, 1 weight
          FROM tr_test_qa
         WHERE id_num IN (:a)) a
 WHERE q.id_num = a.id_num(+) AND DECODE (q.weight - NVL (a.weight, 0), 0, 1, 0) = 0