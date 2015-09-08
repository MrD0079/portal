/* Formatted on 10/06/2015 15:14:54 (QP5 v5.227.12220.39724) */
  SELECT b.*, TO_CHAR (b.visitdate, 'dd.mm.yyyy') visitdate_txt
    FROM rep_spd_visits b
   WHERE dt = TO_DATE (:month_list, 'dd.mm.yyyy') AND tn = :tn
ORDER BY visitdate