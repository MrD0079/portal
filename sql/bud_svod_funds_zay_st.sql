/* Formatted on 07.11.2017 18:24:38 (QP5 v5.252.13127.32867) */
  SELECT fil_id,
         st,
         st_name,
         COUNT (*) c,
         SUM (z_plan) z_plan,
         SUM (z_fakt) z_fakt,
         SUM (compens_distr) compens_distr,
         SUM (compens_db) compens_db
    FROM (  SELECT z.fil fil_id,
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
                                  -   NVL (
                                         (SELECT discount
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
                   CASE
                      WHEN z.cost_assign_month BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                                   AND TO_DATE ( :ed, 'dd.mm.yyyy')
                      THEN
                         1
                   END
                      cost_assign_month_is_in_period,
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
                                   AND accept_order =
                                          DECODE (
                                             NVL (
                                                (SELECT MAX (accept_order)
                                                   FROM bud_ru_zay_accept
                                                  WHERE     z_id = z.id
                                                        AND accepted = 2),
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
                                                        AND rep_accepted
                                                               IS NOT NULL
                                                        AND INN_not_ReportMA (tn) =
                                                               0),
                                             (SELECT MAX (accept_order)
                                                FROM bud_ru_zay_accept
                                               WHERE     z_id = z.id
                                                     AND rep_accepted = 2
                                                     AND INN_not_ReportMA (tn) = 0)))
                              rep_current_accepted_id,
                           st.name st_name,
                           kat.name kat_name,
                             (  NVL (getZayFieldVal (z.id, 'var_name', 'v3'), 0)
                              + NVL (getZayFieldVal (z.id, 'var_name', 'v4'), 0))
                           * 1000
                              z_plan,
                             (  NVL (getZayFieldVal (z.id, 'rep_var_name', 'rv3'),
                                     0)
                              + NVL (getZayFieldVal (z.id, 'rep_var_name', 'rv4'),
                                     0))
                           * 1000
                              z_fakt,
                           NVL (TO_NUMBER (getZayFieldVal (z.id, 'admin_id', 8)),
                                0)
                              by_goods,
                           NVL (TO_NUMBER (getZayFieldVal (z.id, 'admin_id', 9)),
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
                           AND (   TRUNC (z.dt_start, 'mm') BETWEEN TO_DATE (
                                                                       :sd,
                                                                       'dd.mm.yyyy')
                                                                AND TO_DATE (
                                                                       :ed,
                                                                       'dd.mm.yyyy')
                                OR z.cost_assign_month BETWEEN TO_DATE (
                                                                  :sd,
                                                                  'dd.mm.yyyy')
                                                           AND TO_DATE (
                                                                  :ed,
                                                                  'dd.mm.yyyy'))
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
                   z.id)
GROUP BY fil_id, st, st_name
ORDER BY fil_id, st_name