/* Formatted on 23/05/2016 11:28:16 (QP5 v5.252.13127.32867) */
  SELECT u.tn emp_svid,
         u.fio emp_name,
         u.pos_name emp_pos,
         TO_CHAR (u.datauvol, 'dd.mm.yyyy') datauvol
    FROM user_list u
   WHERE     u.dpt_id = :dpt_id
         AND (   u.tn IN (SELECT slave
                            FROM full
                           WHERE master IN (SELECT parent
                                              FROM assist
                                             WHERE child = :tn
                                            UNION
                                            SELECT :tn FROM DUAL))
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_traid_kk, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_kpr, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND u.is_ts = 1
ORDER BY emp_name