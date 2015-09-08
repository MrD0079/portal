/* Formatted on 28/01/2015 10:46:01 (QP5 v5.227.12220.39724) */
/*
SELECT *
  FROM (
*/

  SELECT l.ID,
         l.login,
         l.tn,
         l.text,
         TO_CHAR (l.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
         fn_getname ( tn) NAME,
         prg
    FROM full_log l
   WHERE     DECODE (:prg, NULL, prg, :prg) = prg
         AND TRUNC (lu) BETWEEN TO_DATE (:dates_list1, 'dd.mm.yyyy')
                            AND TO_DATE (:dates_list2, 'dd.mm.yyyy')
ORDER BY ID DESC
/*
) WHERE ROWNUM < 1000
*/