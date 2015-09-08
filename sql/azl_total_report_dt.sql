/* Formatted on 20.02.2013 15:34:55 (QP5 v5.163.1008.3004) */
  SELECT TO_CHAR (dt.dt, 'dd.mm.yyyy') dt,
         avkr.rep_tm avk_rep_tm,
         avkr.text avk_text,
         agr.rep_tm ag_rep_tm,
         agr.count_byu ag_count_byu,
         agr.stock_start ag_stock_start,
         agr.stock_finish ag_stock_finish,
         agr.stock_shelf ag_stock_shelf,
         agr.text ag_text,
         avkr.id avk_id
    FROM (SELECT dt
            FROM azl_tz_ag_report
           WHERE tz_id = :tz_id
          UNION
          SELECT dt
            FROM azl_tz_report
           WHERE tz_id = :tz_id
          UNION
          SELECT dt
            FROM azl_files
           WHERE tz = :tz_id
          UNION
          SELECT dt
            FROM azl_ag_files
           WHERE tz = :tz_id) dt,
         azl_tz_ag_report agr,
         azl_tz_report avkr
   WHERE dt.dt = agr.dt(+) AND dt.dt = avkr.dt(+) AND :tz_id = agr.tz_id(+) AND :tz_id = avkr.tz_id(+) AND dt.dt BETWEEN TO_DATE (:sdt, 'dd.mm.yyyy') AND TO_DATE (:edt, 'dd.mm.yyyy')
ORDER BY dt.dt