/* Formatted on 14/08/2014 12:23:14 (QP5 v5.227.12220.39724) */
  SELECT TO_CHAR (DT, 'dd.mm.yyyy') dt,
         KOD_AG,
         KOD_TP,
         TP_NAME,
         TO_CHAR (TIME_IN, 'dd.mm.yyyy hh24:mi:ss') time_in_c,
         TO_CHAR (TIME_OUT, 'dd.mm.yyyy hh24:mi:ss') time_out_c,
         KOD_LOGGER
    FROM merch_report_gps
   WHERE dt BETWEEN TO_DATE (:dates_list1, 'dd.mm.yyyy')
                AND TO_DATE (:dates_list2, 'dd.mm.yyyy')
ORDER BY dt DESC, KOD_AG, time_in DESC