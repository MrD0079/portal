/* Formatted on 27.03.2018 13:13:18 (QP5 v5.252.13127.32867) */
  SELECT c.mt || ' ' || c.y period_text,
         m.m,
         m.dt,
         u1.chief_tn,
         u1.chief_fio,
         u1.tn ts_tn,
         u1.fio ts_fio,
         m.h_eta,
         m.eta,
         m.tp_kod,
         m.tp_type,
         m.tp_ur,
         m.tp_addr,
         zp.fil,
         m.summa,
         m.summskidka skidka_val,
         NVL (sv.bonus_fakt, 0) + NVL (sv.fixed_fakt, 0) total,
         act.bonus act_bonus,
         act_local.bonus_sum act_local_bonus,
         zay.zat zay_zat,
           NVL (act.bonus, 0)
         + NVL (act_local.bonus_sum, 0)
         + NVL (zay.zat, 0)
         + NVL (sv.bonus_fakt, 0)
         + NVL (sv.fixed_fakt, 0)
         - NVL (m.summskidka, 0)
            zat_total,
         DECODE (
            NVL (m.summa, 0),
            0, 0,
              (  NVL (act.bonus, 0)
               + NVL (act_local.bonus_sum, 0)
               + NVL (zay.zat, 0)
               + NVL (sv.bonus_fakt, 0)
               + NVL (sv.fixed_fakt, 0)
               - NVL (m.summskidka, 0))
            / m.summa
            * 100)
            zat_perc,
         NVL (ROUND (m.skidka), 0) - NVL (f.nacenka_base0, 0) discount_tp,
         CASE
            WHEN tun.tp_kod IS NOT NULL
            THEN
                  'скидка: '
               || tun.discount
               || ', наценка: '
               || tun.margin
               || ', факт оплата: '
               || tun.fixed
               || ', ретро: '
               || tun.bonus
               || ', обоснование предоставления: '
               || tun.justification
            WHEN sc_tp.tp_kod IS NOT NULL
            THEN
                  'скидка: '
               || sc_tp.discount
               || ', наценка: '
               || sc_tp.margin
               || ', факт оплата: '
               || sc_tp.fixed
               || ', ретро: '
               || sc_tp.bonus
               || ', обоснование предоставления: '
               || sc_tp.justification
         END
            tus
    FROM bud_svod_zp zp,
         bud_fil f,
         (SELECT *
            FROM a14mega
           WHERE dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                        AND TO_DATE ( :ed, 'dd.mm.yyyy')) m,
         departments d,
         calendar1stday c,
         user_list u1,
         sc_svod sv,
         (SELECT *
            FROM sc_tp
           WHERE dpt_id = :dpt_id) sc_tp,
         (  SELECT f.act_month, st.tp_kod, SUM (st.bonus) bonus
              FROM bud_act_fund f, act_svodt st
             WHERE     f.act = st.act
                   AND st.dpt_id = :dpt_id
                   AND TO_CHAR (f.act_month, 'mm') = st.m
                   AND DECODE ( :st, 0, 0, 1) = 0
          GROUP BY f.act_month, st.tp_kod) act,
         (  SELECT z.cost_assign_month period,
                   tp.tp_kod,
                   SUM (tp.bonus_sum) bonus_sum
              FROM bud_ru_zay z, akcii_local_tp tp
             WHERE     z.id = tp.z_id
                   AND z.kat IN (SELECT id
                                   FROM BUD_RU_st_ras
                                  WHERE la = 1)
                   AND z.valid_no = 0
                   AND NVL (
                          (SELECT rep_accepted
                             FROM bud_ru_zay_accept
                            WHERE     z_id = z.id
                                  AND INN_not_ReportMA (tn) = 0
                                  AND accept_order =
                                         DECODE (
                                            NVL (
                                               (SELECT MAX (accept_order)
                                                  FROM bud_ru_zay_accept
                                                 WHERE     z_id = z.id
                                                       AND rep_accepted = 2
                                                       AND INN_not_ReportMA (tn) =
                                                              0),
                                               0),
                                            0, (SELECT MAX (accept_order)
                                                  FROM bud_ru_zay_accept
                                                 WHERE     z_id = z.id
                                                       AND rep_accepted IS NOT NULL
                                                       AND INN_not_ReportMA (tn) =
                                                              0),
                                            (SELECT MAX (accept_order)
                                               FROM bud_ru_zay_accept
                                              WHERE     z_id = z.id
                                                    AND rep_accepted = 2
                                                    AND INN_not_ReportMA (tn) = 0))),
                          0) = 1
                   AND DECODE ( :st, 0, z.st, :st) = z.st
                   AND z.cost_assign_month BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                               AND TO_DATE ( :ed, 'dd.mm.yyyy')
          GROUP BY z.cost_assign_month, tp.tp_kod
            HAVING SUM (tp.bonus_sum) > 0) act_local,
         (  SELECT period, SUM (z_fakt) zat, tp_kod
              FROM (SELECT TRUNC (z1.dt_start, 'mm') period,
                             (  NVL (getZayFieldVal (z1.id, 'rep_var_name', 'rv3'),
                                     0)
                              + NVL (getZayFieldVal (z1.id, 'rep_var_name', 'rv4'),
                                     0))
                           * 1000
                              z_fakt,
                           NVL (TO_NUMBER (getZayFieldVal (z1.id, 'admin_id', 4)),
                                0)
                              tp_kod
                      FROM bud_ru_zay z1
                     WHERE     z1.kat NOT IN (SELECT id
                                                FROM BUD_RU_st_ras
                                               WHERE la = 1)
                           AND z1.valid_no = 0
                           AND DECODE ( :st, 0, z1.st, :st) = z1.st
                           AND NVL (
                                  (SELECT accepted
                                     FROM bud_ru_zay_accept
                                    WHERE     z_id = z1.id
                                          AND accept_order =
                                                 DECODE (
                                                    NVL (
                                                       (SELECT MAX (accept_order)
                                                          FROM bud_ru_zay_accept
                                                         WHERE     z_id = z1.id
                                                               AND accepted = 2),
                                                       0),
                                                    0, (SELECT MAX (accept_order)
                                                          FROM bud_ru_zay_accept
                                                         WHERE z_id = z1.id),
                                                    (SELECT MAX (accept_order)
                                                       FROM bud_ru_zay_accept
                                                      WHERE     z_id = z1.id
                                                            AND accepted = 2))),
                                  0) = 1
                           AND (SELECT COUNT (*)
                                  FROM bud_ru_zay_accept
                                 WHERE z_id = z1.id AND accepted = 2) = 0)
             WHERE period BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                              AND TO_DATE ( :ed, 'dd.mm.yyyy')
          GROUP BY period, tp_kod) zay,
         (  SELECT tp_kod,
                   chain,
                   data,
                   COUNT (*) tu_count,
                   AVG (delay) delay,
                   AVG (discount) discount,
                   AVG (bonus) bonus,
                   AVG (fixed) fixed,
                   AVG (margin) margin,
                   wm_concat (DISTINCT justification) justification
              FROM (SELECT z.id,
                           c.data,
                           TRUNC (z.dt_start, 'mm') period_start,
                           TRUNC (z.dt_end, 'mm') period_end,
                           TO_NUMBER (getZayFieldVal (z.id, 'admin_id', 14)) chain,
                           TO_NUMBER (getZayFieldVal (z.id, 'admin_id', 4)) tp_kod,
                           TO_NUMBER (getZayFieldVal (z.id, 'var1', 710)) delay,
                           TO_NUMBER (getZayFieldVal (z.id, 'var1', 1000)) discount,
                           TO_NUMBER (getZayFieldVal (z.id, 'var1', 1010)) bonus,
                           TO_NUMBER (getZayFieldVal (z.id, 'var1', 1020)) fixed,
                           TO_NUMBER (getZayFieldVal (z.id, 'var1', 735)) margin,
                           getZayFieldVal (z.id, 'var1', 1) justification
                      FROM bud_ru_zay z, user_list u, calendar1stday c
                     WHERE     (SELECT NVL (tu, 0)
                                  FROM bud_ru_st_ras
                                 WHERE id = z.kat) = 1
                           AND z.tn = u.tn
                           AND z.report_data IS NOT NULL
                           AND c.data BETWEEN TRUNC (z.dt_start, 'mm')
                                          AND TRUNC (z.dt_end, 'mm')
                           AND c.data BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                          AND TO_DATE ( :ed, 'dd.mm.yyyy')
                           AND NVL (
                                  (SELECT rep_accepted
                                     FROM bud_ru_zay_accept
                                    WHERE     z_id = z.id
                                          AND INN_not_ReportMA (tn) = 0
                                          AND accept_order =
                                                 DECODE (
                                                    NVL (
                                                       (SELECT MAX (accept_order)
                                                          FROM bud_ru_zay_accept
                                                         WHERE     z_id = z.id
                                                               AND rep_accepted = 2
                                                               AND INN_not_ReportMA (
                                                                      tn) = 0),
                                                       0),
                                                    0, (SELECT MAX (accept_order)
                                                          FROM bud_ru_zay_accept
                                                         WHERE     z_id = z.id
                                                               AND rep_accepted
                                                                      IS NOT NULL
                                                               AND INN_not_ReportMA (
                                                                      tn) = 0),
                                                    (SELECT MAX (accept_order)
                                                       FROM bud_ru_zay_accept
                                                      WHERE     z_id = z.id
                                                            AND rep_accepted = 2
                                                            AND INN_not_ReportMA (
                                                                   tn) = 0))),
                                  0) = 1
                           AND TO_NUMBER (getZayFieldVal (z.id, 'admin_id', 4))
                                  IS NOT NULL
                           AND u.dpt_id = :dpt_id)
          GROUP BY tp_kod, chain, data) tun
   WHERE     zp.dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                       AND TO_DATE ( :ed, 'dd.mm.yyyy')
         AND zp.dpt_id = :dpt_id
         AND zp.fil IS NOT NULL
         AND zp.fil = f.id
         AND zp.h_eta = m.h_eta
         AND zp.dt = m.dt
         AND zp.dt = c.data
         AND m.tp_kod = tun.tp_kod(+)
         AND m.dt = tun.data(+)
         AND m.tp_kod = sc_tp.tp_kod(+)
         AND m.tp_kod = sv.tp_kod(+)
         AND m.dt = sv.dt(+)
         AND m.tab_num = u1.tab_num
         AND u1.dpt_id = :dpt_id
         AND u1.is_spd = 1
         AND m.dt = act.act_month(+)
         AND m.tp_kod = act.tp_kod(+)
         AND m.dt = act_local.period(+)
         AND m.tp_kod = act_local.tp_kod(+)
         AND m.dt = zay.period(+)
         AND m.tp_kod = zay.tp_kod(+)
         AND (   :exp_list_without_ts = 0
              OR u1.tn IN (SELECT slave
                             FROM full
                            WHERE master = :exp_list_without_ts))
         AND (   :exp_list_only_ts = 0
              OR u1.tn IN (SELECT slave
                             FROM full
                            WHERE master = :exp_list_only_ts))
         AND (   u1.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_traid_kk, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND ( :eta_list IS NULL OR :eta_list = m.h_eta)
         AND DECODE ( :tp_kod, 0, m.tp_kod, :tp_kod) = m.tp_kod
         AND d.manufak = m.country
         AND d.dpt_id = :dpt_id
         AND (   :zatgt0 = 1
              OR (    :zatgt0 = 2
                  AND   NVL (act.bonus, 0)
                      + NVL (act_local.bonus_sum, 0)
                      + NVL (zay.zat, 0) > 0))
ORDER BY DECODE ( :sort,  2, zat_total,  3, zat_perc,  NULL) DESC,
         u1.chief_fio,
         u1.fio,
         m.eta,
         m.tp_ur,
         m.dt