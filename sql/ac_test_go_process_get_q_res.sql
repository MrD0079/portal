/* Formatted on 12/09/2014 13:29:54 (QP5 v5.227.12220.39724) */
SELECT DECODE (COUNT (*), 0, 1, 0)
  FROM (SELECT id, name, a_ok weight
          FROM ac_test
         WHERE parent = :q) q,
       (SELECT id, name, a_ok weight
          FROM ac_test
         WHERE id IN (:a)) a
 WHERE q.id = a.id(+) AND DECODE (q.weight - NVL (a.weight, 0), 0, 1, 0) = 0