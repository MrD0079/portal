/* Formatted on 03.01.2013 10:45:06 (QP5 v5.163.1008.3004) */
  SELECT u.*, p.parent
    FROM user_list u, parents p
   WHERE     (u.tn IN (SELECT slave
                         FROM full
                        WHERE master = :tn)
              OR (SELECT is_traid
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND u.is_db = 1
         AND u.dpt_id = :dpt_id
         AND u.tn = p.tn
ORDER BY u.fio