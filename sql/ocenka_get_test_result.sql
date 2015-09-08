/* Formatted on 15.01.2013 11:08:52 (QP5 v5.163.1008.3004) */
SELECT SUM (s.score)
  FROM ocenka_score s
 WHERE s.exp_tn = :tn AND s.tn IS NULL AND s.event = :event