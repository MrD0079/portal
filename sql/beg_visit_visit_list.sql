/* Formatted on 14.04.2014 15:58:18 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT
         r.tp_kod,
         r.tp_name || ', ' || r.address || ', ' || r.tp_kod || ', ' || r.eta
            name,
         r.tp_name,
         r.address,
         r.eta,
         r.tp_type,
         TO_CHAR (v.lu, 'dd.mm.yyyy hh24:mi:ss') lu_t, v.lu
    FROM beg_visit_head v, routes r
   WHERE tn = :tn AND dt = TO_DATE (:dt, 'dd.mm.yyyy') AND r.tp_kod = v.tp_kod
ORDER BY v.lu, r.eta, name