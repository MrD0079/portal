/* Formatted on 24.05.2012 13:21:11 (QP5 v5.163.1008.3004) */
  SELECT fio, tn
    FROM user_list
/*   WHERE dpt_id = :dpt_id*/
where is_spd=1
ORDER BY fio