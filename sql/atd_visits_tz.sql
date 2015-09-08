/* Formatted on 21.02.2013 13:53:10 (QP5 v5.163.1008.3004) */
  SELECT d.name diviz,
         c.name city,
         n.name nets,
         tz.addr,
         cavk.fio cavk_fio,
         cag.fio cag_fio,
         COUNT (DISTINCT dt.avk_id) avk_visits,
         COUNT (DISTINCT dt.ag_id) ag_visits
    FROM atd_tz tz,
         atd_city c,
         atd_diviz d,
         atd_nets n,
         atd_contr_avk cavk,
         atd_contr_ag cag,
         user_list u,
         (SELECT TO_CHAR (dt.dt, 'dd.mm.yyyy') dt,
                 dt.tz_id,
                 avkr.rep_tm avk_rep_tm,
                 avkr.text avk_text,
                 agr.rep_tm ag_rep_tm,
                 agr.count_byu ag_count_byu,
                 agr.stock_start ag_stock_start,
                 agr.stock_finish ag_stock_finish,
                 agr.stock_shelf ag_stock_shelf,
                 agr.text ag_text,
                 avkr.id avk_id,
                 agr.id ag_id,
                 (SELECT COUNT (*)
                    FROM atd_tz_report_params z
                   WHERE z.rep_id = avkr.id AND val <> 0)
                    ball_cnt,
                 (SELECT COUNT (*)
                    FROM atd_files
                   WHERE tz = dt.tz_id AND dt = dt.dt)
                    avk_files,
                 (SELECT COUNT (*)
                    FROM atd_ag_files
                   WHERE tz = dt.tz_id AND dt = dt.dt)
                    ag_files
            FROM (SELECT dt, tz_id FROM atd_tz_ag_report
                  UNION
                  SELECT dt, tz_id FROM atd_tz_report
                  UNION
                  SELECT dt, tz FROM atd_files
                  UNION
                  SELECT dt, tz FROM atd_ag_files) dt,
                 atd_tz_ag_report agr,
                 atd_tz_report avkr
           WHERE dt.dt = agr.dt(+) AND dt.dt = avkr.dt(+) AND dt.tz_id = agr.tz_id(+) AND dt.tz_id = avkr.tz_id(+) AND dt.dt BETWEEN TO_DATE (:sdt, 'dd.mm.yyyy') AND TO_DATE (:edt, 'dd.mm.yyyy')) dt
   WHERE tz.city = c.id(+) AND tz.nets = n.id(+) AND tz.diviz = d.id(+) AND tz.contr_avk = cavk.id(+) AND tz.contr_ag = cag.id(+) AND tz.cont_avk = u.tn(+) AND tz.id = dt.tz_id(+)
GROUP BY d.name,
         c.name,
         n.name,
         tz.addr,
         cavk.fio,
         cag.fio
ORDER BY COUNT (DISTINCT dt.avk_id) DESC,
         COUNT (DISTINCT dt.ag_id) DESC,
         d.name,
         c.name,
         n.name,
         tz.addr,
         cavk.fio,
         cag.fio