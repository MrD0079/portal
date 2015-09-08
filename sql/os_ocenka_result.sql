/* Formatted on 01.03.2013 10:03:08 (QP5 v5.163.1008.3004) */
SELECT fn_get_score_tn (:tn, 'self_score_t', :event) self_score_t,
       fn_get_score_tn (:tn, 'chief_score_t', :event) chief_score_t,
       fn_get_score_tn (:tn, 'exp_avg_score_t', :event) exp_avg_score_t,
       fn_get_score_tn (:tn, 'score_t', :event) score_t,
       (SELECT SUM (s.score)
          FROM ocenka_score s
         WHERE s.exp_tn = :tn AND s.tn IS NULL AND s.event = :event)
          test_result
  FROM DUAL