/* Formatted on 03/10/2014 15:25:47 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT w.slave emp_svid,
                  u.fio emp_name,
                  u.pos_name emp_pos,
                  TO_CHAR (u.datauvol, 'dd.mm.yyyy') datauvol
    FROM full w, user_list u
   WHERE     u.dpt_id = :dpt_id
         AND u.tn = w.slave
         AND (   w.master IN (SELECT parent
                                FROM assist
                               WHERE child = :tn
                              UNION
                              SELECT :tn FROM DUAL)
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