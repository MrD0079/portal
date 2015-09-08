/* Formatted on 21.02.2013 13:53:22 (QP5 v5.163.1008.3004) */
  SELECT dt.*
    FROM akr_tz tz,
         akr_city c,
         akr_diviz d,
         akr_nets n,
         akr_contr_avk cavk,
         (SELECT TO_CHAR (dt.dt, 'dd.mm.yyyy') dt,
                 dt.dt dtdt,
                 dt.tz_id,
                 avkr.rep_tm avk_rep_tm,
                 avkr.id avk_id,
                 (SELECT COUNT (*)
                    FROM akr_tz_report_params z
                   WHERE z.rep_id = avkr.id AND val <> 0)
                    ball_cnt,
                 (SELECT COUNT (*)
                    FROM akr_files
                   WHERE tz = dt.tz_id AND dt = dt.dt)
                    avk_files
            FROM (SELECT dt, tz_id FROM akr_tz_report
                  UNION
                  SELECT dt, tz FROM akr_files) dt,
                 akr_tz_report avkr
           WHERE dt.dt = avkr.dt(+) AND dt.tz_id = avkr.tz_id(+)) dt
   WHERE     tz.city = c.id(+)
         AND tz.nets = n.id(+)
         AND tz.diviz = d.id(+)
         AND tz.contr_avk = cavk.id(+)
         AND tz.id = dt.tz_id(+)
         AND cavk.id = :id
         AND dt.avk_id IS NOT NULL
         AND dt.dtdt BETWEEN TO_DATE (:sdt, 'dd.mm.yyyy') AND TO_DATE (:edt, 'dd.mm.yyyy')
ORDER BY dtdt, avk_rep_tm