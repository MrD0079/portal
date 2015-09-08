/* Formatted on 05.12.2013 12:18:41 (QP5 v5.227.12220.39724) */
  SELECT COUNT (*) c, full
    FROM (SELECT f.full, f.slave tn
            FROM full f, user_list u
           WHERE     f.dpt_id = :dpt_id
                 AND f.master = :tn
                 AND u.tn = f.slave
                 AND NVL (u.is_top, 0) <> 1
                 AND u.datauvol IS NULL)
GROUP BY full