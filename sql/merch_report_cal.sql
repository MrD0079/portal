/* Formatted on 25/11/2015 12:32:46 PM (QP5 v5.252.13127.32867) */
  SELECT c.id,
         TO_CHAR (c.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
         l.*,
         f.id freq_id,
         f.name freq_name
    FROM (SELECT a.id ag_id,
                 a.name ag_name,
                 r.id rep_id,
                 r.name rep_name
            FROM routes_agents a, merch_report_cal_rep r) l,
         merch_report_cal c,
         merch_report_cal_freq f
   WHERE     l.ag_id = c.ag_id
         AND l.rep_id = c.rep_id
         AND TO_DATE ( :dt, 'dd.mm.yyyy') = c.dt(+)
         AND c.freq_id = f.id
ORDER BY ag_name, rep_name, f.name