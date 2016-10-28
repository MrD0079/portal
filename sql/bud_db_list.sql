/* Formatted on 07/06/2016 11:37:57 (QP5 v5.252.13127.32867) */
  SELECT u.*, p.parent, TO_CHAR (u.datauvol, 'dd.mm.yyyy') datauvol
    FROM user_list u, parents p
   WHERE     (   u.tn IN (SELECT slave
                            FROM full
                           WHERE master = :tn)
              OR (SELECT is_traid
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND u.is_db = 1
         AND u.dpt_id = :dpt_id
         AND u.tn = p.tn
ORDER BY u.fio