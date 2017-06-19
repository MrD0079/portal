/* Formatted on 11/05/2016 12:16:56 (QP5 v5.252.13127.32867) */
SELECT COUNT (*) c,
       COUNT (DISTINCT tp_kod) tpc,
       SUM (summa) summa,
       SUM (skidka_val) skidka_val,
       SUM (total) total,
       SUM (act_bonus) act_bonus,
       SUM (act_local_bonus) act_local_bonus,
       SUM (zay_zat) zay_zat,
       SUM (zat_total) zat_total,
       DECODE (NVL (SUM (summa), 0),
               0, 0,
               (SUM (zat_total)) / SUM (summa) * 100)
          zat_perc
  FROM (  SELECT c.mt || ' ' || m.y period_text,
                 m.m,
                 m.dt,
                 pu.tn chief_tn,
                 pu.fio chief_fio,
                 u1.tn ts_tn,
                 u1.fio ts_fio,
                 m.h_eta,
                 m.eta,
                 m.tp_kod,
                 m.tp_type,
                 m.tp_ur,
                 m.tp_addr,
                 m.tp_type,
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
                    zat_perc
            FROM bud_svod_zp zp,
                 a14mega m,
                 departments d,
                 (SELECT DISTINCT TRUNC (data, 'mm') data, mt
                    FROM calendar
                   WHERE data BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                  AND TO_DATE ( :ed, 'dd.mm.yyyy')) c,
                 user_list u1,
                 user_list pu,
                 parents p,
                 sc_svod sv,
                 (  SELECT f.act_month, st.tp_kod, SUM (st.bonus) bonus
                      FROM bud_act_fund f, act_svodt st
                     WHERE     f.act = st.act
                           AND st.dpt_id = :dpt_id
                           AND TO_CHAR (f.act_month, 'mm') = st.m
                           AND DECODE ( :st, 0, 0, 1) = 0
                  GROUP BY f.act_month, st.tp_kod) act,
                 (  SELECT TRUNC (z.dt_start, 'mm') period,
                           tp.tp_kod,
                           SUM (tp.bonus_sum) bonus_sum
                      FROM bud_ru_zay z, akcii_local_tp tp
                     WHERE     z.id = tp.z_id
                           AND z.kat IN (SELECT id
                                           FROM BUD_RU_st_ras
                                          WHERE la = 1)
                           AND z.valid_no = 0
                           AND (SELECT rep_accepted
                                  FROM bud_ru_zay_accept
                                 WHERE     z_id = z.id
                                       AND accept_order =
                                              DECODE (
                                                 NVL (
                                                    (SELECT MAX (accept_order)
                                                       FROM bud_ru_zay_accept
                                                      WHERE     z_id = z.id
                                                            AND rep_accepted = 2),
                                                    0),
                                                 0, (SELECT MAX (accept_order)
                                                       FROM bud_ru_zay_accept
                                                      WHERE     z_id = z.id
                                                            AND rep_accepted
                                                                   IS NOT NULL),
                                                 (SELECT MAX (accept_order)
                                                    FROM bud_ru_zay_accept
                                                   WHERE     z_id = z.id
                                                         AND rep_accepted = 2))) =
                                  1
                           AND DECODE ( :st, 0, z.st, :st) = z.st
                  GROUP BY TRUNC (z.dt_start, 'mm'), tp.tp_kod) act_local,
                 (  SELECT period, SUM (z_fakt) zat, tp_kod
                      FROM (SELECT TRUNC (z1.dt_start, 'mm') period,
                                   (SELECT rep_val_number * 1000
                                      FROM bud_ru_zay_ff
                                     WHERE     ff_id IN (SELECT id
                                                           FROM bud_ru_ff
                                                          WHERE     dpt_id =
                                                                       :dpt_id
                                                                AND rep_var_name IN ('rv3',
                                                                                     'rv4'))
                                           AND z_id = z1.id)
                                      z_fakt,
                                   (SELECT val_list
                                      FROM bud_ru_zay_ff
                                     WHERE     ff_id IN (SELECT id
                                                           FROM bud_ru_ff
                                                          WHERE     dpt_id =
                                                                       :dpt_id
                                                                AND admin_id = 4)
                                           AND z_id = z1.id)
                                      tp_kod,
                                   DECODE (
                                      (SELECT COUNT (*)
                                         FROM bud_ru_zay_accept
                                        WHERE z_id = z1.id AND accepted = 2),
                                      0, 0,
                                      1)
                                      deleted,
                                   (SELECT accepted
                                      FROM bud_ru_zay_accept
                                     WHERE     z_id = z1.id
                                           AND accept_order =
                                                  DECODE (
                                                     NVL (
                                                        (SELECT MAX (
                                                                   accept_order)
                                                           FROM bud_ru_zay_accept
                                                          WHERE     z_id = z1.id
                                                                AND accepted = 2),
                                                        0),
                                                     0, (SELECT MAX (
                                                                   accept_order)
                                                           FROM bud_ru_zay_accept
                                                          WHERE z_id = z1.id),
                                                     (SELECT MAX (accept_order)
                                                        FROM bud_ru_zay_accept
                                                       WHERE     z_id = z1.id
                                                             AND accepted = 2)))
                                      current_accepted_id
                              FROM bud_ru_zay z1
                             WHERE     z1.kat NOT IN (SELECT id
                                                        FROM BUD_RU_st_ras
                                                       WHERE la = 1)
                                   AND z1.valid_no = 0
                                   AND DECODE ( :st, 0, z1.st, :st) = z1.st)
                     WHERE current_accepted_id = 1 AND deleted = 0
                  GROUP BY period, tp_kod) zay
           WHERE     zp.dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                               AND TO_DATE ( :ed, 'dd.mm.yyyy')
                 AND zp.dpt_id = :dpt_id
                 AND zp.fil IS NOT NULL
                 AND zp.h_eta = m.h_eta
                 AND zp.dt = m.dt
                 AND zp.dt = c.data
                 AND m.tp_kod = sv.tp_kod(+)
                 AND m.dt = sv.dt(+)
                 AND m.tab_num = u1.tab_num
                 AND u1.dpt_id = :dpt_id
           and u1.is_spd=1
      AND p.tn = u1.tn
                 AND p.parent = pu.tn
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
                 AND (:eta_list is null OR :eta_list = m.h_eta)
                 AND DECODE ( :tp_kod, 0, m.tp_kod, :tp_kod) = m.tp_kod
                 AND d.manufak = m.country
                 AND d.dpt_id = :dpt_id
        ORDER BY DECODE ( :sort,  2, zat_total,  3, zat_perc,  NULL) DESC,
                 pu.fio,
                 u1.fio,
                 m.eta,
                 m.tp_ur,
                 m.dt)