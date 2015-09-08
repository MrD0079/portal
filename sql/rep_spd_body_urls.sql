/* Formatted on 10/06/2015 15:22:52 (QP5 v5.227.12220.39724) */
SELECT *
  FROM rep_spd_urls b
 WHERE     dt = TO_DATE (:month_list, 'dd.mm.yyyy')
       AND tn = :tn
       AND visitdate = TO_DATE (:visitdate, 'dd.mm.yyyy')
       AND tp_kod = :tp_kod
       AND h_eta = :h_eta