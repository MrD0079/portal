/* Formatted on 06.09.2013 14:55:56 (QP5 v5.227.12220.39724) */
  SELECT u.fio, u.tn, u.dpt_name
    FROM user_list u
   WHERE u.datauvol IS NULL AND u.dpt_id = :dpt_id AND U.IS_COACH = 1
ORDER BY fio