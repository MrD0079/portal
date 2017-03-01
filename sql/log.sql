/* Formatted on 01.03.2017 13:27:03 (QP5 v5.252.13127.32867) */
  SELECT l.ID,
         l.login,
         l.tn,
         l.text,
         TO_CHAR (l.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
         fn_getname (tn) NAME,
         prg
    FROM full_log l
   WHERE     (LENGTH ( :prg) IS NULL OR prg LIKE :prg)
         AND TRUNC (lu) BETWEEN TO_DATE ( :dates_list1, 'dd.mm.yyyy')
                            AND TO_DATE ( :dates_list2, 'dd.mm.yyyy')
ORDER BY ID DESC