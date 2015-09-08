/* Formatted on 15/04/2015 18:29:47 (QP5 v5.227.12220.39724) */
  SELECT u.tn id, u.fio fio
    FROM user_list u
   WHERE     :dpt_id = u.dpt_id
         AND u.datauvol IS NULL
         AND u.is_spd = 1
         /*AND u.tn <> :tn
         AND (   u.tn IN (SELECT slave
                            FROM full
                           WHERE master = :tn)
              OR (SELECT is_traid
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT is_traid_kk
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT is_coach
                    FROM user_list
                   WHERE tn = :tn) = 1)*/
ORDER BY u.fio