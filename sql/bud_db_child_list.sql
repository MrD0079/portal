/* Formatted on 13.06.2013 14:38:08 (QP5 v5.227.12220.39724) */
  SELECT *
    FROM user_list
   WHERE tn IN (SELECT slave
                  FROM full
                 WHERE master IN (SELECT tn
                                    FROM user_list u
                                   WHERE     (   u.tn IN (SELECT slave
                                                            FROM full
                                                           WHERE master = :tn)
                                              OR (SELECT is_traid
                                                    FROM user_list
                                                   WHERE tn = :tn) = 1)
                                         AND is_db = 1
                                         AND dpt_id = :dpt_id))
ORDER BY fio