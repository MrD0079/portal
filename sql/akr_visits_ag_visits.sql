/* Formatted on 21.02.2013 13:53:48 (QP5 v5.163.1008.3004) */
  SELECT dt.*
    FROM akr_tz tz,
         akr_city c,
         akr_diviz d,
         akr_nets n,
         akr_contr_ag cag,
         (SELECT TO_CHAR (dt.dt, 'dd.mm.yyyy') dt,
                 dt.dt dtdt,
                 dt.tz_id,
                 agr.rep_tm ag_rep_tm,
                 agr.id ag_id,
                 (SELECT COUNT (*)
                    FROM akr_ag_files
                   WHERE tz = dt.tz_id AND dt = dt.dt)
                    ag_files
            FROM (SELECT dt, tz_id FROM akr_tz_ag_report
                  UNION
                  SELECT dt, tz FROM akr_ag_files) dt,
                 akr_tz_ag_report agr
           WHERE dt.dt = agr.dt(+) AND dt.tz_id = agr.tz_id(+)) dt
   WHERE     tz.city = c.id(+)
         AND tz.nets = n.id(+)
         AND tz.diviz = d.id(+)
         AND tz.contr_ag = cag.id(+)
         AND tz.id = dt.tz_id(+)
         AND cag.id = :id
         AND dt.ag_id IS NOT NULL
         AND dt.dtdt BETWEEN TO_DATE (:sdt, 'dd.mm.yyyy') AND TO_DATE (:edt, 'dd.mm.yyyy')
ORDER BY dtdt, ag_rep_tm