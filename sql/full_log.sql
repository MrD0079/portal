/* Formatted on 22.03.2017 12:12:37 (QP5 v5.252.13127.32867) */
SELECT *
  FROM (  SELECT ROW_NUMBER () OVER (ORDER BY id DESC) rn,
                 l.ID,
                 l.login,
                 l.tn,
                 l.text,
                 TO_CHAR (l.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
                 fn_getname (tn) NAME,
                 prg
            FROM :table l
           WHERE     (LENGTH ( :prg) IS NULL OR prg LIKE :prg)
                 AND TRUNC (lu) BETWEEN TO_DATE ( :dates_list1, 'dd.mm.yyyy')
                                    AND TO_DATE ( :dates_list2, 'dd.mm.yyyy')
        ORDER BY ID DESC)
 WHERE    rn BETWEEN :r1 AND :r2
       OR LENGTH ( :r1) IS NULL
       OR LENGTH ( :r2) IS NULL