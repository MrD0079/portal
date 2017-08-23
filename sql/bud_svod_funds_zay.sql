/* Formatted on 22.08.2017 14:04:14 (QP5 v5.252.13127.32867) */
  SELECT z.fil fil_id,
         z.*,
         CASE
            WHEN via_db = 1
            THEN
               NULL
            ELSE
               CASE
                  WHEN by_goods = 0
                  THEN
                     z_fakt
                  ELSE
                       z_fakt
                     * (  1
                        -   NVL ( (SELECT discount
                                     FROM bud_fil_discount_body
                                    WHERE dt = z.period AND distr = z.fil),
                                 0)
                          / 100)
                     * (SELECT bonus_log_koef
                          FROM bud_fil
                         WHERE id = z.fil)
               END
         END
            compens_distr,
         CASE WHEN via_db = 1 THEN z_fakt ELSE NULL END compens_db,
         (SELECT mt || ' ' || y
            FROM calendar
           WHERE data = z.cost_assign_month)
            cost_assign_month_text,
         CASE WHEN z.cost_assign_month BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy') AND TO_DATE ( :ed, 'dd.mm.yyyy') THEN 1 END cost_assign_month_is_in_period,
         (SELECT mt || ' ' || y
            FROM calendar
           WHERE data = z.period)
            period_text
    FROM (SELECT TRUNC (z.dt_start, 'mm') period,
                 z.*,
                 DECODE ( (SELECT COUNT (*)
                             FROM bud_ru_zay_accept
                            WHERE z_id = z.id AND accepted = 2),
                         0, 0,
                         1)
                    deleted,
                 (SELECT accepted
                    FROM bud_ru_zay_accept
                   WHERE     z_id = z.id
                         AND accept_order = DECODE (NVL ( (SELECT MAX (accept_order)
                                                             FROM bud_ru_zay_accept
                                                            WHERE z_id = z.id AND accepted = 2),
                                                         0),
                                                    0, (SELECT MAX (accept_order)
                                                          FROM bud_ru_zay_accept
                                                         WHERE z_id = z.id),
                                                    (SELECT MAX (accept_order)
                                                       FROM bud_ru_zay_accept
                                                      WHERE z_id = z.id AND accepted = 2)))
                    current_accepted_id,
                 (SELECT rep_accepted
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
                                                      WHERE z_id = z.id AND rep_accepted = 2 AND INN_not_ReportMA (tn) = 0)))
                    rep_current_accepted_id,
                 st.name st_name,
                 kat.name kat_name,
                 (SELECT val_number * 1000
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN (SELECT id
                                         FROM bud_ru_ff
                                        WHERE dpt_id = :dpt_id AND var_name IN ('v3', 'v4'))
                         AND z_id = z.id)
                    z_plan,
                 (SELECT rep_val_number * 1000
                    FROM bud_ru_zay_ff
                   WHERE     ff_id IN (SELECT id
                                         FROM bud_ru_ff
                                        WHERE dpt_id = :dpt_id AND rep_var_name IN ('rv3', 'rv4'))
                         AND z_id = z.id)
                    z_fakt,
                 NVL ( (SELECT val_bool
                          FROM bud_ru_zay_ff
                         WHERE     ff_id IN (SELECT id
                                               FROM bud_ru_ff
                                              WHERE dpt_id = :dpt_id AND admin_id = 8)
                               AND z_id = z.id),
                      0)
                    by_goods,
                 NVL ( (SELECT val_bool
                          FROM bud_ru_zay_ff
                         WHERE     ff_id IN (SELECT id
                                               FROM bud_ru_ff
                                              WHERE dpt_id = :dpt_id AND admin_id = 9)
                               AND z_id = z.id),
                      0)
                    via_db,
                 NVL (kat.tu, 0) tu
            FROM bud_ru_zay z,
                 user_list u,
                 BUD_RU_st_ras st,
                 BUD_RU_st_ras kat
           WHERE     z.tn = u.tn
                 AND z.st = st.id(+)
                 AND z.kat = kat.id(+)
                 AND NVL (kat.la, 0) = 0
         AND (TRUNC (z.dt_start, 'mm') BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy') AND TO_DATE ( :ed, 'dd.mm.yyyy') OR z.cost_assign_month BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy') AND TO_DATE ( :ed, 'dd.mm.yyyy'))
                 AND (   :exp_list_without_ts = 0
                      OR u.tn IN (SELECT slave
                                    FROM full
                                   WHERE master = :exp_list_without_ts))
                 AND (   :exp_list_only_ts = 0
                      OR u.tn IN (SELECT slave
                                    FROM full
                                   WHERE master = :exp_list_only_ts))
                 AND (   u.tn IN (SELECT slave
                                    FROM full
                                   WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1
                      OR (SELECT NVL (is_traid_kk, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)
                 AND u.tn = DECODE ( :db, 0, u.tn, :db)
                 AND z.funds = DECODE ( :funds, 0, z.funds, :funds)
                 AND z.valid_no = 0
                 AND DECODE ( :st, 0, z.st, :st) = z.st) z
   WHERE current_accepted_id = 1 AND deleted = 0
ORDER BY period,
         fil,
         st_name,
         z.id