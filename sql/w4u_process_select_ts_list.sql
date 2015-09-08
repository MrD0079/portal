/* Formatted on 12.03.2013 13:38:01 (QP5 v5.163.1008.3004) */
  SELECT *
    FROM user_list u
   WHERE     u.dpt_id = :dpt_id
         AND (u.tn IN (SELECT slave
                         FROM full
                        WHERE master = :tn)
              OR (SELECT NVL (is_super, 0) + NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) > 0)
         AND u.pos_id IN (57)
ORDER BY fio