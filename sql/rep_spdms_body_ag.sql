/* Formatted on 26/08/2015 14:32:04 (QP5 v5.227.12220.39724) */
  SELECT ag_id,
         ag_name,
         plan,
         fakt,
         oos,
         comm,
         tasks
    FROM rep_spdms_visits b
   WHERE     dt = TO_DATE (:month_list, 'dd.mm.yyyy')
         AND tn = :tn
         AND visitdate = TO_DATE (:visitdate, 'dd.mm.yyyy')
         AND tp_kod = :tp_kod
ORDER BY ag_name