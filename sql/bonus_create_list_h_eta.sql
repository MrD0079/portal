/* Formatted on 15/04/2015 18:30:34 (QP5 v5.227.12220.39724) */
  SELECT h_eta id, eta fio
    FROM PARENTS_ETA
   WHERE     (   chief_tn IN (SELECT slave
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
                   WHERE tn = :tn) = 1)
         AND dpt_id = :dpt_id
ORDER BY eta