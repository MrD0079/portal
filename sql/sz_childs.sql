/* Formatted on 17.09.2012 15:35:32 (QP5 v5.163.1008.3004) */
  SELECT u.*
    FROM user_list u
   WHERE     dpt_id = :dpt_id
         AND is_kk IS NULL
         AND is_rm IS NULL
         AND is_tm IS NULL
         AND is_ts IS NULL
         AND is_nm IS NULL
         AND is_mservice = 0
         AND datauvol IS NULL
ORDER BY fio