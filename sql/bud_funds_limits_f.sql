/* Formatted on 11/03/2015 16:27:23 (QP5 v5.227.12220.39724) */
  SELECT f.id,
         f.name,
         fd.plan_val,
         fd.plan_perc,
         fd.planl_val,
         fd.planl_perc,
         NVL (fd.plan_val, 0) + NVL (fd.planl_val, 0) plan_total,
         fakt.fakt fakt_val,
         DECODE (
            (NVL (fd.plan_val, 0) + NVL (fd.planl_val, 0)),
            0, 0,
              NVL (fakt.fakt, 0)
            / (NVL (fd.plan_val, 0) + NVL (fd.planl_val, 0))
            * 100)
            fakt_perc,
         DECODE (
            NVL (
               (SELECT plan
                  FROM bud_funds_limits_b b
                 WHERE     b.dt = TO_DATE (:month_list, 'dd.mm.yyyy')
                       AND b.dpt_id = :dpt_id
                       AND b.db = :db
                       AND b.kk = :kk),
               0),
            0, 0,
              fakt.fakt
            / NVL (
                 (SELECT plan
                    FROM bud_funds_limits_b b
                   WHERE     b.dt = TO_DATE (:month_list, 'dd.mm.yyyy')
                         AND b.dpt_id = :dpt_id
                         AND b.db = :db
                         AND b.kk = :kk),
                 0)
            * 100)
            sales_perc
    FROM bud_funds f,
         bud_funds_limits_f fd,
         (  SELECT z.tn, z.funds, SUM (z_fakt.val_number) fakt
              FROM bud_ru_zay z,
                   (SELECT z_id, val_number
                      FROM bud_ru_zay_ff
                     WHERE ff_id IN (SELECT id
                                       FROM bud_ru_ff
                                      WHERE var_name IN ('v3', 'v4') AND dpt_id = :dpt_id)) z_fakt,
                   user_list u
             WHERE     z.tn = u.tn
                   AND NVL (u.is_kk, 0) = :kk
                   AND u.dpt_id = :dpt_id
                   AND TRUNC (z.dt_start, 'mm') =
                          TO_DATE (:month_list, 'dd.mm.yyyy')
                   AND z.id = z_fakt.z_id
                   AND report_data IS NOT NULL
                   AND (SELECT accepted
                          FROM bud_ru_zay_accept
                         WHERE     z_id = z.id
                               AND accept_order =
                                      DECODE (
                                         NVL (
                                            (SELECT MAX (accept_order)
                                               FROM bud_ru_zay_accept
                                              WHERE     z_id = z.id
                                                    AND accepted = 464262),
                                            0),
                                         0, (SELECT MAX (accept_order)
                                               FROM bud_ru_zay_accept
                                              WHERE z_id = z.id),
                                         (SELECT MAX (accept_order)
                                            FROM bud_ru_zay_accept
                                           WHERE     z_id = z.id
                                                 AND accepted = 464262))) =
                          464261
          /*AND (SELECT rep_accepted
                        FROM bud_ru_zay_accept
                       WHERE     z_id = z.id
                             AND accept_order =
                                    DECODE (
                                       NVL (
                                          (SELECT MAX (accept_order)
                                             FROM bud_ru_zay_accept
                                            WHERE z_id = z.id AND rep_accepted = 464262),
                                          0),
                                       0, (SELECT MAX (accept_order)
                                             FROM bud_ru_zay_accept
                                            WHERE     z_id = z.id
                                                  AND rep_accepted IS NOT NULL),
                                       (SELECT MAX (accept_order)
                                          FROM bud_ru_zay_accept
                                         WHERE z_id = z.id AND rep_accepted = 464262))) =
                        464261*/
          /*раскомменитровать,
          если все-таки нужно будет брать
          согласованные отчеты, а не заявки*/
          GROUP BY z.tn, z.funds) fakt
   WHERE     f.dpt_id = :dpt_id
         AND f.planned = 1
         AND fd.fund(+) = f.id
         AND fd.dt(+) = TO_DATE (:month_list, 'dd.mm.yyyy')
         AND fd.dpt_id(+) = :dpt_id
         AND fd.db(+) = :db
         AND fd.kk(+) = :kk
         AND fakt.tn(+) = :db
         AND fakt.funds(+) = f.id
ORDER BY f.name