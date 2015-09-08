/* Formatted on 25.03.2014 15:58:54 (QP5 v5.227.12220.39724) */
SELECT id
  FROM beg_visit_head h
 WHERE     h.dt = TO_DATE (:dt, 'dd.mm.yyyy')
       AND h.tp_kod = :tp_kod
       AND h.tn = :tn