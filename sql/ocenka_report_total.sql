/* Formatted on 01.03.2013 13:08:03 (QP5 v5.163.1008.3004) */
SELECT COUNT (*) c,
       AVG (self_score) self_score,
       AVG (chief_score) chief_score,
       AVG (test_score) test_score,
       AVG (exp_avg_score) exp_avg_score,
       AVG (chief_plus_exp_avg_score) chief_plus_exp_avg_score,
       AVG (total_score) total_score,
       SUM (DECODE (dev_chief, 'да', 1, 0)) dev_chief,
       SUM (DECODE (dev_sol, 'да', 1, 0)) dev_sol,
       SUM (DECODE (dev_emp, 'да', 1, 0)) dev_emp
  FROM (SELECT ROWNUM,
               emp_tn,
               fio,
               pos_name,
               self_score,
               chief_score,
               test_score,
               exp_avg_score,
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
               + NVL (test_score, 0)
                  total_score,
               CASE WHEN dev_chief = 1 THEN 'да' ELSE 'нет' END dev_chief,
               CASE WHEN dev_sol = 1 THEN 'да' ELSE 'нет' END dev_sol,
               CASE WHEN dev_emp = 1 THEN 'да' ELSE 'нет' END dev_emp
          FROM (SELECT e.emp_tn,
                       fn_getname ( e.emp_tn) fio,
                       (SELECT pos_name
                          FROM pos
                         WHERE pos_id = (SELECT pos_id
                                           FROM spdtree
                                          WHERE svideninn = e.emp_tn))
                          pos_name,
                       (SELECT SUM (s.score * c.weight)
                          FROM ocenka_criteria c, ocenka_score s
                         WHERE s.tn = e.emp_tn AND s.exp_tn = e.emp_tn AND s.event = e1.year AND s.criteria = c.id_num AND c.event = e1.year AND s.event = e1.year)
                          self_score,
                       (SELECT SUM (s.score * c.weight)
                          FROM ocenka_score s, ocenka_criteria c, emp_exp ee
                         WHERE s.criteria = c.id_num AND s.tn = e.emp_tn AND s.tn = ee.emp_tn AND s.exp_tn = ee.exp_tn AND ee.FULL = 1 AND s.event = e1.year AND c.event = e1.year)
                          chief_score,
                       (SELECT SUM (s.score * c.weight) / COUNT (e1.year)
                          FROM ocenka_score s, ocenka_criteria c, emp_exp ee
                         WHERE     s.criteria = c.id_num
                               AND s.tn = e.emp_tn
                               AND s.tn = ee.emp_tn
                               AND s.exp_tn = ee.exp_tn
                               AND ee.FULL = 0
                               AND s.event = e1.year
                               AND c.event = e1.year
                               AND s.exp_tn <> e.emp_tn)
                          exp_avg_score,
                       (SELECT SUM (s.score)
                          FROM ocenka_score s
                         WHERE s.exp_tn = e.emp_tn AND s.tn IS NULL AND s.event = e1.year)
                          test_score,
                       (SELECT dev_chief
                          FROM ocenka_exp_comment ec
                         WHERE ec.exp_tn = e.emp_tn AND ec.tn = ec.exp_tn AND ec.event = e1.year)
                          dev_chief,
                       (SELECT dev_sol
                          FROM ocenka_exp_comment ec
                         WHERE ec.exp_tn = e.emp_tn AND ec.tn = ec.exp_tn AND ec.event = e1.year)
                          dev_sol,
                       (SELECT dev_emp
                          FROM ocenka_exp_comment ec
                         WHERE ec.exp_tn = e.emp_tn AND ec.tn = ec.exp_tn AND ec.event = e1.year)
                          dev_emp
                  FROM (SELECT DISTINCT emp_tn FROM emp_exp) e,
                       user_list u,
                       ocenka_events e1,
                       parents p
                 WHERE     u.tn = e.emp_tn
                       AND u.dpt_id = :dpt_id
                       AND e1.year = :event
                       AND p.tn = u.tn
                       AND p.parent IN (SELECT slave
                                          FROM full
                                         WHERE master = DECODE (:parent, 0, p.parent, :parent))
                       AND u.pos_id = DECODE (:pos, 0, u.pos_id, :pos)
                       AND u.tn = DECODE (:spd, 0, u.tn, :spd)) z
         WHERE self_score IS NOT NULL OR chief_score IS NOT NULL OR exp_avg_score IS NOT NULL OR test_score IS NOT NULL)