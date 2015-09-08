/* Formatted on 26/08/2015 14:28:30 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT b.visitdate,
                  obl,
                  city,
                  net_name,
                  tp_ur,
                  tp_addr,
                  tp_kod,
                  TO_CHAR (b.visitdate, 'dd.mm.yyyy') visitdate_txt
    FROM rep_spdms_visits b
   WHERE dt = TO_DATE (:month_list, 'dd.mm.yyyy') AND tn = :tn
ORDER BY visitdate,
         obl,
         city,
         net_name,
         tp_ur,
         tp_addr