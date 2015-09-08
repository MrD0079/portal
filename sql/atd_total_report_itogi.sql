/* Formatted on 21.02.2013 8:39:29 (QP5 v5.163.1008.3004) */
SELECT COUNT (DISTINCT tz.id) tz,
       COUNT (DISTINCT dt.avk_id) avk_visits,
       COUNT (DISTINCT dt.avk_id)
       / AVG ( (SELECT COUNT (*)
                  FROM calendar
                 WHERE data BETWEEN TO_DATE (:sdt, 'dd.mm.yyyy') AND TO_DATE (:edt, 'dd.mm.yyyy')))
          avk_visits_avg,
       SUM (DECODE (NVL (dt.avk_text, ''), '', 0, 1)) avk_texts,
       SUM (dt.ball_cnt) avk_balls,
       COUNT (DISTINCT dt.ag_id) ag_visits,
       COUNT (DISTINCT dt.ag_id)
       / AVG ( (SELECT COUNT (*)
                  FROM calendar
                 WHERE data BETWEEN TO_DATE (:sdt, 'dd.mm.yyyy') AND TO_DATE (:edt, 'dd.mm.yyyy')))
          ag_visits_avg,
       SUM (DECODE (NVL (dt.ag_text, ''), '', 0, 1)) ag_texts,
       SUM (dt.ag_count_byu) ag_count_byu,
       SUM (dt.avk_files) avk_files,
       SUM (dt.ag_files) ag_files
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
 WHERE     tz.city = c.id(+)
       AND tz.nets = n.id(+)
       AND tz.diviz = d.id(+)
       AND tz.contr_avk = cavk.id(+)
       AND tz.contr_ag = cag.id(+)
       AND tz.cont_avk = u.tn(+)
       AND tz.id = DECODE (:tz_id, 0, tz.id, :tz_id)
       AND tz.nets = DECODE (:nets, 0, tz.nets, :nets)
       AND tz.diviz = DECODE (:diviz, 0, tz.diviz, :diviz)
       AND tz.city = DECODE (:city, 0, tz.city, :city)
       AND tz.contr_avk = DECODE (:atd_contr_avk, 0, tz.contr_avk, :atd_contr_avk)
       AND tz.contr_ag = DECODE (:atd_contr_ag, 0, tz.contr_ag, :atd_contr_ag)
       AND tz.id = dt.tz_id(+)
       AND tz.id IN (SELECT tz.id
                       FROM atd_tz tz,
                            atd_nets an,
                            nets n,
                            atd_contr_avk aca
                      WHERE     tz.nets = an.id
                            AND an.kod = n.sw_kod(+)
                            AND tz.contr_avk = aca.id(+)
                            AND   DECODE ( (SELECT DECODE (NVL (is_mkk, 0) + NVL (is_rmkk, 0), 0, 0, 1)
                                              FROM user_list
                                             WHERE tn = :tn)
                                          + DECODE (DECODE (n.tn_mkk, :tn, 1, 0) + DECODE (n.tn_rmkk, :tn, 1, 0), 0, 0, 1),
                                          2, 1,
                                          0)
                                + DECODE (aca.inn, :tn, 1, 0)
                                + (SELECT is_super
                                     FROM atd_contr_avk
                                    WHERE inn = :tn) <> 0)