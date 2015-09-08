/* Formatted on 15.01.2013 11:10:50 (QP5 v5.163.1008.3004) */
  SELECT z.*,
         chief_score * weight chief_score_t,
         exp_avg_score * weight exp_avg_score_t,
         CASE
            WHEN chief_score IS NOT NULL AND exp_avg_score IS NOT NULL THEN (chief_score + exp_avg_score) / 2
            WHEN chief_score IS NOT NULL AND exp_avg_score IS NULL THEN chief_score
            WHEN chief_score IS NULL AND exp_avg_score IS NOT NULL THEN exp_avg_score
            ELSE 0
         END
            chief_plus_exp_avg_score,
         CASE
            WHEN chief_score IS NOT NULL AND exp_avg_score IS NOT NULL THEN (chief_score + exp_avg_score) / 2
            WHEN chief_score IS NOT NULL AND exp_avg_score IS NULL THEN chief_score
            WHEN chief_score IS NULL AND exp_avg_score IS NOT NULL THEN exp_avg_score
            ELSE 0
         END
         * z.weight
            total_score
    FROM (SELECT c.id_num,
                 c.NAME,
                 c.description,
                 c.weight,
                 (SELECT score
                    FROM ocenka_score
                   WHERE criteria = c.id_num AND tn = :tn AND exp_tn = :tn AND event = c.event)
                    self_score,
                 (SELECT s.score
                    FROM ocenka_score s, emp_exp ee
                   WHERE s.criteria = c.id_num AND s.tn = :tn AND s.event = c.event AND s.tn = ee.emp_tn AND s.exp_tn = ee.exp_tn AND ee.FULL = 1)
                    chief_score,
                 (SELECT SUM (s.score) / COUNT (s.score)
                    FROM ocenka_score s, emp_exp ee
                   WHERE s.criteria = c.id_num AND s.tn = :tn AND s.event = c.event AND s.tn = ee.emp_tn AND s.exp_tn = ee.exp_tn AND s.exp_tn <> :tn AND ee.FULL = 0)
                    exp_avg_score
            FROM ocenka_criteria c
           WHERE c.event = :event
                 AND c.pos = (SELECT pos_id
                                FROM spdtree
                               WHERE svideninn = :tn)) z
ORDER BY NAME