/* Formatted on 03.08.2017 13:32:00 (QP5 v5.252.13127.32867) */
  SELECT s.net_kod,
         s.net,
         s.isrc,
         s.db,
         COUNT (*) tp_cnt,
         t.delay,
         t.discount,
         t.bonus,
         t.fixed,
         t.margin,
         SUM (s.summa) summa,
         DECODE (sv.net_kod, NULL, NULL, 1) selected,
         SUM (s.summa) * t.bonus / 100 bonus_tp,
         NVL (sv.fixed_fakt, 0) fixed_fakt,
         NVL (sv.bonus_fakt, 0) + NVL (sv.fixed_fakt, 0) total,
         DECODE (SUM (s.summa), 0, 0, (NVL (sv.bonus_fakt, 0) + NVL (sv.fixed_fakt, 0)) / SUM (s.summa) * 100) zat,
         sv.lu_fio,
         sv.lu_tn,
         TO_CHAR (sv.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
         DECODE (SUM (summa), 0, 0, -SUM (s.summskidka) / SUM (summa) * 100) skidka,
         -SUM (s.summskidka) skidka_val,
         sv.bonus_fakt,
         NVL (sv.fixed_fakt, 0) + SUM (s.summa) * t.bonus / 100 maxtp,
         sv.cash,
           (NVL (sv.bonus_fakt, 0) + NVL (sv.fixed_fakt, 0))
         * CASE
              WHEN NVL (sv.cash, 0) = 1
              THEN
                 1
              ELSE
                 SUM (  (  1
                         -   NVL ( (SELECT discount
                                      FROM bud_fil_discount_body
                                     WHERE dt = TO_DATE ( :dt, 'dd.mm.yyyy') AND distr = zp.fil),
                                  0)
                           / 100)
                      * (SELECT bonus_log_koef
                           FROM bud_fil
                          WHERE id = zp.fil))
           END
            compens_distr,
         taf.ok_db_tn taf_ok_db_tn
    FROM (SELECT tpn.net_kod,
                 tpn.net,
                 tpn.isrc,
                 u.tn,
                 p.parent db,
                 m.tab_num,
                 m.tp_kod,
                 m.y,
                 m.m,
                 NVL (m.summa, 0) + NVL (m.coffee, 0) summa,
                 m.h_eta,
                 m.eta,
                 m.skidka,
                 m.summskidka,
                 m.bedt_summ,
                 m.tp_type,
                 m.tp_ur,
                 m.tp_addr
            FROM a14mega m,
                 user_list u,
                 parents p,
                 tp_nets tpn
           WHERE m.tp_kod = tpn.tp_kod AND u.tn = p.tn AND m.dpt_id = :dpt_id AND TO_DATE ( :dt, 'dd.mm.yyyy') = m.dt AND u.tab_num = m.tab_num AND u.dpt_id = m.dpt_id) s,
         (SELECT z_all.chain,
                 z_all.delay,
                 z_all.discount,
                 z_all.bonus,
                 z_all.fixed,
                 z_all.margin
            FROM (SELECT z.dt_start,
                         z.id,
                         TO_NUMBER (getZayFieldVal (z.id, 'admin_id', 14)) chain,
                         TO_NUMBER (getZayFieldVal (z.id, 'var1', 710)) delay,
                         TO_NUMBER (getZayFieldVal (z.id, 'var1', 1000)) discount,
                         TO_NUMBER (getZayFieldVal (z.id, 'var1', 1010)) bonus,
                         TO_NUMBER (getZayFieldVal (z.id, 'var1', 1020)) fixed,
                         TO_NUMBER (getZayFieldVal (z.id, 'var1', 735)) margin
                    FROM bud_ru_zay z, user_list u
                   WHERE     (SELECT NVL (tu, 0)
                                FROM bud_ru_st_ras
                               WHERE id = z.kat) = 1
                         AND z.tn = u.tn
                         AND u.dpt_id = :dpt_id
                         AND TO_DATE ( :dt, 'dd.mm.yyyy') /*= z.cost_assign_month*/ BETWEEN TRUNC (z.dt_start, 'mm') AND TRUNC (z.dt_end, 'mm')
                         AND z.report_data IS NOT NULL
                         AND (SELECT rep_accepted
                                FROM bud_ru_zay_accept
                               WHERE     z_id = z.id
                                     AND INN_not_ReportMA (tn) = 0
                                     AND accept_order = DECODE (NVL ( (SELECT MAX (accept_order)
                                                                         FROM bud_ru_zay_accept
                                                                        WHERE z_id = z.id AND rep_accepted = 2 AND INN_not_ReportMA (tn) = 0),
                                                                     0),
                                                                0, (SELECT MAX (accept_order)
                                                                      FROM bud_ru_zay_accept
                                                                     WHERE z_id = z.id AND rep_accepted IS NOT NULL AND INN_not_ReportMA (tn) = 0),
                                                                (SELECT MAX (accept_order)
                                                                   FROM bud_ru_zay_accept
                                                                  WHERE z_id = z.id AND rep_accepted = 2 AND INN_not_ReportMA (tn) = 0))) = 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     /*0*/
                         AND TO_NUMBER (getZayFieldVal (z.id, 'admin_id', 14)) IS NOT NULL) z_all,
                 (  SELECT MAX (z.dt_start) dt_start, TO_NUMBER (getZayFieldVal (z.id, 'admin_id', 14)) chain
                      FROM bud_ru_zay z, user_list u
                     WHERE     (SELECT NVL (tu, 0)
                                  FROM bud_ru_st_ras
                                 WHERE id = z.kat) = 1
                           AND z.tn = u.tn
                           AND u.dpt_id = :dpt_id
                           AND TO_DATE ( :dt, 'dd.mm.yyyy') /*= z.cost_assign_month*/ BETWEEN TRUNC (z.dt_start, 'mm') AND TRUNC (z.dt_end, 'mm')
                           AND z.report_data IS NOT NULL
                           AND (SELECT rep_accepted
                                  FROM bud_ru_zay_accept
                                 WHERE     z_id = z.id
                                       AND INN_not_ReportMA (tn) = 0
                                       AND accept_order = DECODE (NVL ( (SELECT MAX (accept_order)
                                                                           FROM bud_ru_zay_accept
                                                                          WHERE z_id = z.id AND rep_accepted = 2 AND INN_not_ReportMA (tn) = 0),
                                                                       0),
                                                                  0, (SELECT MAX (accept_order)
                                                                        FROM bud_ru_zay_accept
                                                                       WHERE z_id = z.id AND rep_accepted IS NOT NULL AND INN_not_ReportMA (tn) = 0),
                                                                  (SELECT MAX (accept_order)
                                                                     FROM bud_ru_zay_accept
                                                                    WHERE z_id = z.id AND rep_accepted = 2 AND INN_not_ReportMA (tn) = 0))) = 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   /*0*/
                           AND TO_NUMBER (getZayFieldVal (z.id, 'admin_id', 14)) IS NOT NULL
                  GROUP BY TO_NUMBER (getZayFieldVal (z.id, 'admin_id', 14)), TO_NUMBER (getZayFieldVal (z.id, 'admin_id', 4))) z_max
           WHERE z_all.chain = z_max.chain AND z_all.dt_start = z_max.dt_start) t,
         sc_svodn sv,
         (SELECT fil, h_eta
            FROM bud_svod_zp
           WHERE dt = TO_DATE ( :dt, 'dd.mm.yyyy') AND dpt_id = :dpt_id AND fil IS NOT NULL) zp,
         (SELECT fil, ok_db_tn
            FROM bud_svod_taf
           WHERE dt = TO_DATE ( :dt, 'dd.mm.yyyy')) taf
   WHERE zp.fil = taf.fil(+) AND s.net_kod = t.chain AND s.net_kod = sv.net_kod(+) AND s.db = sv.db(+) AND TO_DATE ( :dt, 'dd.mm.yyyy') = sv.dt(+) AND :dpt_id = sv.dpt_id(+) AND zp.h_eta = s.h_eta AND s.net_kod = :net_kod AND s.db = :db
GROUP BY s.net_kod,
         s.net,
         s.isrc,
         t.delay,
         t.discount,
         t.bonus,
         t.fixed,
         t.margin,
         s.db,
         sv.net_kod,
         sv.fixed_fakt,
         sv.bonus_fakt,
         sv.lu_fio,
         sv.lu_tn,
         sv.lu,
         sv.cash,
         taf.ok_db_tn