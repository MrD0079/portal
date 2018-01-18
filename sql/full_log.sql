/* Formatted on 16.01.2018 19:46:33 (QP5 v5.252.13127.32867) */
SELECT *
  FROM (  SELECT ROW_NUMBER () OVER (ORDER BY l.id DESC) rn,
                 l.ID,
                 l.login,
                 l.tn,
                 l.text,
                 TO_CHAR (l.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
                 u.fio NAME,
                 l.prg,
                 l.ip
            FROM full_log l, user_list u
           WHERE     l.login = u.login(+)
                 AND (LENGTH ( :prg) IS NULL OR l.prg LIKE :prg)
                 AND l.lu_dt BETWEEN TO_DATE ( :dates_list1, 'dd.mm.yyyy')
                                 AND TO_DATE ( :dates_list2, 'dd.mm.yyyy')
        ORDER BY l.ID DESC)
 WHERE rn BETWEEN :r1 AND :r2 OR LENGTH ( :r1) IS NULL OR LENGTH ( :r2) IS NULL