/* Formatted on 23/05/2016 11:30:53 (QP5 v5.252.13127.32867)
    fix emp_name
*/
  SELECT u.tn emp_svid,
         u.fio emp_name,
         u.pos_name emp_pos,
         TO_CHAR (u.datauvol, 'dd.mm.yyyy') datauvol,
         u.is_ts
    FROM user_list u
   WHERE     u.dpt_id = :dpt_id
         AND (   u.tn IN (SELECT parent
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
         AND NVL (u.is_ts, 0) <> 1
         AND (u.datauvol IS NULL OR u.tn = 3130406555) /* fix 09.10.2019 отобразить ТМ Соловьева */
         AND EXISTS
                (SELECT *
                   FROM parents
                  WHERE parent = u.tn)
ORDER BY emp_name