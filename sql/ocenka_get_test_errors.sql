/* Formatted on 15.01.2013 11:08:43 (QP5 v5.163.1008.3004) */
  SELECT ROWNUM,
         c.NAME,
         c.description,
         s.score
    FROM (SELECT *
            FROM ocenka_score s
           WHERE exp_tn = :tn AND tn IS NULL AND event = :event) s,
         ocenka_criteria c
   WHERE c.id_num = s.criteria(+) AND c.event = s.event(+) AND c.event = :event AND TYPE = 5 AND NVL (s.score, 0) = 0
ORDER BY c.num