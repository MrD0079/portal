/* Formatted on 07.02.2017 17:38:26 (QP5 v5.252.13127.32867) */
  SELECT data,
         y,
         my,
         mt,
         COUNT (*) cnt,
         SUM (summa) summa,
         SUM (total) + AVG (total_net) total,
         SUM (act_bonus) act_bonus,
         SUM (act_local_bonus) act_local_bonus,
         SUM (zay_zat) zay_zat,
         SUM (zat_total) zat_total,
         DECODE (
            NVL (SUM (summa), 0),
            0, 0,
              (SUM (zat_total) + SUM (total) + AVG (total_net))
            / SUM (summa)
            * 100)
            zat_perc,
         AVG (sku) sku,
         AVG (skidka) skidka
    FROM (  SELECT c.data,
                   c.y,
                   c.my,
                   c.mt,
                   c.tp_kod,
                   c.tp_ur,
                   c.tp_addr,
                   m.summa,
                   m.total,
                   m.act_bonus,
                   m.act_local_bonus,
                   m.zay_zat,
                   m.zat_total,
                   m.zat_perc,
                   m.sku,
                   m.skidka,
                   SUM (svs_new_view.total) total_net
              FROM svs_new_view,
                   (SELECT *
                      FROM calendar c,
                           (  SELECT tp_kod,
                                     MAX (tp_ur) tp_ur,
                                     MAX (tp_addr) tp_addr
                                FROM a14mega m
                               WHERE     m.tp_kod IN (SELECT tp_kod
                                                        FROM tp_nets
                                                       WHERE net_kod =
                                                                TO_NUMBER (
                                                                   getZayFieldVal (
                                                                      :z_id,
                                                                      'admin_id',
                                                                      14)))
                                     AND m.dpt_id = :zayDptId
                            GROUP BY tp_kod) m
                     WHERE     c.data BETWEEN (SELECT ADD_MONTHS (
                                                         TRUNC (dt_start, 'yyyy'),
                                                         -12)
                                                         sd
                                                 FROM bud_ru_zay
                                                WHERE id = :z_id)
                                          AND (SELECT ADD_MONTHS (
                                                         TRUNC (dt_start, 'mm'),
                                                         -1)
                                                 FROM bud_ru_zay
                                                WHERE id = :z_id)
                           AND c.data = TRUNC (data, 'mm')) c,
                   (  SELECT dt,
                             m,
                             tp_kod,
                             SUM (summa) summa,
                             SUM (total) total,
                             SUM (act_bonus) act_bonus,
                             SUM (act_local_bonus) act_local_bonus,
                             SUM (zay_zat) zay_zat,
                             SUM (zat_total) zat_total,
                             DECODE (
                                NVL (SUM (summa), 0),
                                0, 0,
                                (SUM (zat_total) + SUM (total)) / SUM (summa) * 100)
                                zat_perc,
                             SUM (sku) sku,
                             AVG (skidka) skidka
                        FROM (SELECT m.dt,
                                     m.m,
                                     m.summa,
                                       NVL (sv.bonus_fakt, 0)
                                     + NVL (sv.fixed_fakt, 0)
                                        total,
                                     act.bonus act_bonus,
                                     act_local.bonus_sum act_local_bonus,
                                     zay.zat zay_zat,
                                       NVL (act.bonus, 0)
                                     + NVL (act_local.bonus_sum, 0)
                                     + NVL (zay.zat, 0)
                                        zat_total,
                                     DECODE (
                                        NVL (m.summa, 0),
                                        0, 0,
                                          (  NVL (act.bonus, 0)
                                           + NVL (act_local.bonus_sum, 0)
                                           + NVL (zay.zat, 0)
                                           + NVL (sv.bonus_fakt, 0)
                                           + NVL (sv.fixed_fakt, 0))
                                        / m.summa
                                        * 100)
                                        zat_perc,
                                     m.sku,
                                     m.tp_kod,
                                     m.skidka skidka
                                FROM bud_svod_zp zp,
                                     a14mega m,
                                     sc_svod sv,
                                     (  SELECT f.act_month,
                                               st.tp_kod,
                                               SUM (st.bonus) bonus,
                                               st.dpt_id
                                          FROM bud_act_fund f, act_svodt st
                                         WHERE     f.act = st.act
                                               AND TO_CHAR (f.act_month, 'mm') = st.m
                                      GROUP BY f.act_month, st.tp_kod, st.dpt_id)
                                     act,
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
                                                                        (SELECT MAX (
                                                                                   accept_order)
                                                                           FROM bud_ru_zay_accept
                                                                          WHERE     z_id =
                                                                                       z.id
                                                                                AND rep_accepted =
                                                                                       2),
                                                                        0),
                                                                     0, (SELECT MAX (
                                                                                   accept_order)
                                                                           FROM bud_ru_zay_accept
                                                                          WHERE     z_id =
                                                                                       z.id
                                                                                AND rep_accepted
                                                                                       IS NOT NULL),
                                                                     (SELECT MAX (
                                                                                accept_order)
                                                                        FROM bud_ru_zay_accept
                                                                       WHERE     z_id =
                                                                                    z.id
                                                                             AND rep_accepted =
                                                                                    2))) =
                                                      1
                                      GROUP BY TRUNC (z.dt_start, 'mm'), tp.tp_kod)
                                     act_local,
                                     (  SELECT period, SUM (z_fakt) zat, tp_kod
                                          FROM (SELECT TRUNC (z1.dt_start, 'mm')
                                                          period,
                                                       (SELECT rep_val_number * 1000
                                                          FROM bud_ru_zay_ff
                                                         WHERE     ff_id IN (SELECT id
                                                                               FROM bud_ru_ff
                                                                              WHERE     dpt_id =
                                                                                           :zayDptId
                                                                                    AND rep_var_name IN ('rv3',
                                                                                                         'rv4'))
                                                               AND z_id = z1.id)
                                                          z_fakt,
                                                       (SELECT val_list
                                                          FROM bud_ru_zay_ff
                                                         WHERE     ff_id IN (SELECT id
                                                                               FROM bud_ru_ff
                                                                              WHERE     dpt_id =
                                                                                           :zayDptId
                                                                                    AND admin_id =
                                                                                           4)
                                                               AND z_id = z1.id)
                                                          tp_kod,
                                                       DECODE (
                                                          (SELECT COUNT (*)
                                                             FROM bud_ru_zay_accept
                                                            WHERE     z_id = z1.id
                                                                  AND accepted = 2),
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
                                                                              WHERE     z_id =
                                                                                           z1.id
                                                                                    AND accepted =
                                                                                           2),
                                                                            0),
                                                                         0, (SELECT MAX (
                                                                                       accept_order)
                                                                               FROM bud_ru_zay_accept
                                                                              WHERE z_id =
                                                                                       z1.id),
                                                                         (SELECT MAX (
                                                                                    accept_order)
                                                                            FROM bud_ru_zay_accept
                                                                           WHERE     z_id =
                                                                                        z1.id
                                                                                 AND accepted =
                                                                                        2)))
                                                          current_accepted_id
                                                  FROM bud_ru_zay z1
                                                 WHERE     z1.kat NOT IN (SELECT id
                                                                            FROM BUD_RU_st_ras
                                                                           WHERE la =
                                                                                    1)
                                                       AND z1.valid_no = 0)
                                         WHERE     current_accepted_id = 1
                                               AND deleted = 0
                                      GROUP BY period, tp_kod) zay
                               WHERE     zp.dpt_id = m.dpt_id
                                     AND zp.fil IS NOT NULL
                                     AND zp.h_eta = m.h_eta
                                     AND zp.dt = m.dt
                                     AND m.tp_kod = sv.tp_kod(+)
                                     AND m.dt = sv.dt(+)
                                     AND m.dpt_id = act.dpt_id(+)
                                     AND m.dt = act.act_month(+)
                                     AND m.tp_kod = act.tp_kod(+)
                                     AND m.dt = act_local.period(+)
                                     AND m.tp_kod = act_local.tp_kod(+)
                                     AND m.dt = zay.period(+)
                                     AND m.tp_kod = zay.tp_kod(+)
                                     AND m.dt BETWEEN (SELECT ADD_MONTHS (
                                                                 TRUNC (dt_start,
                                                                        'yyyy'),
                                                                 -12)
                                                                 sd
                                                         FROM bud_ru_zay
                                                        WHERE id = :z_id)
                                                  AND (SELECT ADD_MONTHS (
                                                                 TRUNC (dt_start,
                                                                        'mm'),
                                                                 -1)
                                                         FROM bud_ru_zay
                                                        WHERE id = :z_id)
                                     AND m.tp_kod IN (SELECT tp_kod
                                                        FROM tp_nets
                                                       WHERE net_kod =
                                                                TO_NUMBER (
                                                                   getZayFieldVal (
                                                                      :z_id,
                                                                      'admin_id',
                                                                      14)))
                                     AND m.dpt_id = :zayDptId)
                    GROUP BY dt, m, tp_kod) m
             WHERE     c.data = m.dt(+)
                   AND c.tp_kod = m.tp_kod(+)
                   AND svs_new_view.net_kod(+) =
                          TO_NUMBER (getZayFieldVal ( :z_id, 'admin_id', 14))
                   AND svs_new_view.dpt_id(+) = :zayDptId
                   AND svs_new_view.dt(+) = c.data
          GROUP BY c.data,
                   c.y,
                   c.my,
                   c.mt,
                   c.tp_kod,
                   c.tp_ur,
                   c.tp_addr,
                   m.summa,
                   m.total,
                   m.act_bonus,
                   m.act_local_bonus,
                   m.zay_zat,
                   m.zat_total,
                   m.zat_perc,
                   m.sku,
                   m.skidka
          ORDER BY c.data, c.my, c.mt) q
GROUP BY data,
         y,
         my,
         mt
ORDER BY data, my, mt