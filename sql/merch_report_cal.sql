/* Formatted on 05/08/2015 19:36:28 (QP5 v5.227.12220.39724) */
  SELECT l.*, f.id freq_id
    FROM (SELECT a.id ag_id,
                 a.name ag_name,
                 r.id rep_id,
                 r.name rep_name
            FROM routes_agents a, merch_report_cal_rep r) l,
         merch_report_cal c,
         merch_report_cal_freq f
   WHERE     l.ag_id = c.ag_id(+)
         AND l.rep_id = c.rep_id(+)
         AND TO_DATE (:dt, 'dd.mm.yyyy') = c.dt(+)
         AND c.freq_id = f.id(+)
ORDER BY ag_name, rep_name