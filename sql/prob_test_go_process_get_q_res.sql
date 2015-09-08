/* Formatted on 17.11.2014 13:08:50 (QP5 v5.227.12220.39724) */
SELECT DECODE (COUNT (*), 0, 1, 0)
  FROM (SELECT id, name, a_ok weight
          FROM prob_test
         WHERE parent = :q) q,
       (SELECT id, name, a_ok weight
          FROM prob_test
         WHERE id IN (:a)) a
 WHERE q.id = a.id(+) AND DECODE (q.weight - NVL (a.weight, 0), 0, 1, 0) = 0