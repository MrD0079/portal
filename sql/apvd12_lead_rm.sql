/* Formatted on 19.11.2012 15:23:12 (QP5 v5.163.1008.3004) */
  SELECT u.fio, u.tn, u.pos_name, DECODE (:TYPE,  1, fn_apvd12_ball (u.tn),  2, fn_apvd12_ball (u.tn) + fn_apvd_ball (u.tn)) ball
    FROM user_list u
   WHERE u.is_rm = 1 AND u.dpt_id = :dpt_id AND u.datauvol IS NULL
ORDER BY ball DESC, u.fio