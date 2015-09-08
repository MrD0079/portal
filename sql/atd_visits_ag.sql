/* Formatted on 21.02.2013 13:54:05 (QP5 v5.163.1008.3004) */
  SELECT cag.fio,
         cag.phone,
         COUNT (DISTINCT dt.ag_id) ag_visits,
         cag.id
    FROM atd_tz tz,
         atd_city c,
         atd_diviz d,
         atd_nets n,
         atd_contr_ag cag,
         (SELECT TO_CHAR (dt.dt, 'dd.mm.yyyy') dt,
                 dt.dt dtdt,
                 dt.tz_id,
                 agr.id ag_id,
                 (SELECT COUNT (*)
                    FROM atd_ag_files
                   WHERE tz = dt.tz_id AND dt = dt.dt)
                    ag_files
            FROM (SELECT dt, tz_id FROM atd_tz_ag_report
                  UNION
                  SELECT dt, tz FROM atd_ag_files) dt,
                 atd_tz_ag_report agr
           WHERE dt.dt = agr.dt(+) AND dt.tz_id = agr.tz_id(+)) dt
   WHERE     tz.city = c.id(+)
         AND tz.nets = n.id(+)
         AND tz.diviz = d.id(+)
         AND tz.contr_ag = cag.id(+)
         AND tz.id = dt.tz_id(+)
         AND dt.dtdt BETWEEN TO_DATE (:sdt, 'dd.mm.yyyy') AND TO_DATE (:edt, 'dd.mm.yyyy')
GROUP BY cag.fio, cag.phone, cag.id
ORDER BY ag_visits DESC, cag.fio, cag.phone