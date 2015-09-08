/* Formatted on 21.11.2013 15:03:45 (QP5 v5.227.12220.39724) */
  SELECT m.*, TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu_txt
    FROM zat_monthly_chat m
   WHERE     m.tn = :tn
         AND TO_DATE ('01' || '.' || m.m || '.' || m.y, 'dd.mm.yy') =
                TO_DATE (:month_list, 'dd.mm.yyyy')
ORDER BY lu