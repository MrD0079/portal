/* Formatted on 07.11.2017 17:25:40 (QP5 v5.252.13127.32867) */
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
            fakt.fakt / (NVL (fd.plan_val, 0) + NVL (fd.planl_val, 0)) * 100)
            fakt_perc,
         DECODE (
            NVL (
               (SELECT plan
                  FROM bud_funds_limits_b b
                 WHERE     b.dt = TO_DATE ( :month_list, 'dd.mm.yyyy')
                       AND b.dpt_id = :dpt_id
                       AND b.db = :db
                       AND b.kk = :kk),
               0),
            0, 0,
              fakt.fakt
            / NVL (
                 (SELECT plan
                    FROM bud_funds_limits_b b
                   WHERE     b.dt = TO_DATE ( :month_list, 'dd.mm.yyyy')
                         AND b.dpt_id = :dpt_id
                         AND b.db = :db
                         AND b.kk = :kk),
                 0)
            * 100)
            sales_perc
    FROM bud_funds f,
         bud_funds_limits_f fd,
         (  SELECT z.tn,
                   z.funds,
                   SUM (
                        NVL (getZayFieldVal (z.id, 'var_name', 'v3'), 0)
                      + NVL (getZayFieldVal (z.id, 'var_name', 'v4'), 0))
                      fakt
              FROM bud_ru_zay z, user_list u
             WHERE     z.tn = u.tn
                   AND NVL (u.is_kk, 0) = :kk
                   AND u.dpt_id = :dpt_id
                   AND TRUNC (z.dt_start, 'mm') =
                          TO_DATE ( :month_list, 'dd.mm.yyyy')
                   AND report_data IS NOT NULL
                   AND (SELECT accepted
                          FROM bud_ru_zay_accept
                         WHERE     z_id = z.id
                               AND accept_order =
                                      DECODE (
                                         NVL (
                                            (SELECT MAX (accept_order)
                                               FROM bud_ru_zay_accept
                                              WHERE z_id = z.id AND accepted = 2),
                                            0),
                                         0, (SELECT MAX (accept_order)
                                               FROM bud_ru_zay_accept
                                              WHERE z_id = z.id),
                                         (SELECT MAX (accept_order)
                                            FROM bud_ru_zay_accept
                                           WHERE z_id = z.id AND accepted = 2))) =
                          1
          GROUP BY z.tn, z.funds) fakt
   WHERE     f.dpt_id = :dpt_id
         AND f.planned = 1
         AND fd.fund(+) = f.id
         AND fd.dt(+) = TO_DATE ( :month_list, 'dd.mm.yyyy')
         AND fd.dpt_id(+) = :dpt_id
         AND fd.db(+) = :db
         AND fd.kk(+) = :kk
         AND fakt.tn(+) = :db
         AND fakt.funds(+) = f.id
         AND f.id = :fund
ORDER BY f.name