/* Formatted on 10.01.2013 13:50:48 (QP5 v5.163.1008.3004) */
  SELECT u.fio,
         u.tn,
         u.dpt_name,
         p.prob_tn
    FROM user_list u, p_prob_inst p
   WHERE u.datauvol IS NULL AND u.dpt_id = :dpt_id AND u.tn = p.prob_tn(+) AND p.prob_tn IS NULL AND u.is_spd = 1
ORDER BY fio