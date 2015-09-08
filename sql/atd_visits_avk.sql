/* Formatted on 21.02.2013 13:53:31 (QP5 v5.163.1008.3004) */
  SELECT cavk.fio,
         cavk.phone,
         COUNT (DISTINCT dt.avk_id) avk_visits,
         cavk.id
    FROM atd_tz tz,
         atd_city c,
         atd_diviz d,
         atd_nets n,
         atd_contr_avk cavk,
         (SELECT TO_CHAR (dt.dt, 'dd.mm.yyyy') dt,
                 dt.dt dtdt,
                 dt.tz_id,
                 avkr.id avk_id,
                 (SELECT COUNT (*)
                    FROM atd_tz_report_params z
                   WHERE z.rep_id = avkr.id AND val <> 0)
                    ball_cnt,
                 (SELECT COUNT (*)
                    FROM atd_files
                   WHERE tz = dt.tz_id AND dt = dt.dt)
                    avk_files
            FROM (SELECT dt, tz_id FROM atd_tz_report
                  UNION
                  SELECT dt, tz FROM atd_files) dt,
                 atd_tz_report avkr
           WHERE dt.dt = avkr.dt(+) AND dt.tz_id = avkr.tz_id(+)) dt
   WHERE     tz.city = c.id(+)
         AND tz.nets = n.id(+)
         AND tz.diviz = d.id(+)
         AND tz.contr_avk = cavk.id(+)
         AND tz.id = dt.tz_id(+)
         AND dt.dtdt BETWEEN TO_DATE (:sdt, 'dd.mm.yyyy') AND TO_DATE (:edt, 'dd.mm.yyyy')
GROUP BY cavk.fio, cavk.phone, cavk.id
ORDER BY avk_visits DESC, cavk.fio, cavk.phone