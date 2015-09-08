/* Formatted on 06.09.2013 8:59:28 (QP5 v5.227.12220.39724) */
  SELECT d.*, DECODE (z.dpt_id, NULL, 0, 1) checked
    FROM departments d,
         (SELECT dpt_id
            FROM dpt_tn
           WHERE tn = :tn) z
   WHERE d.dpt_id = z.dpt_id(+)
ORDER BY d.sort