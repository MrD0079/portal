/* Formatted on 11/03/2015 15:40:06 (QP5 v5.227.12220.39724) */
  SELECT dbf.id,
         dbf.name,
         SUM (fd.plan_val) plan_val,
         SUM (fd.plan_perc) plan_perc,
         SUM (fd.planl_val) planl_val,
         SUM (fd.planl_perc) planl_perc,
         SUM (NVL (fd.plan_val, 0) + NVL (fd.planl_val, 0)) plan_total,
         SUM (fakt.fakt) fakt_val,
         DECODE (
            SUM (NVL (fd.plan_val, 0) + NVL (fd.planl_val, 0)),
            0, 0,
              SUM (fakt.fakt)
            / SUM ( (NVL (fd.plan_val, 0) + NVL (fd.planl_val, 0)))
            * 100)
            fakt_perc,
         accepted.plan_val accepted_plan_val,
         accepted.planl_val accepted_planl_val
    FROM (  SELECT l.tn,
                   b.plan,
                   f.id,
                   f.name
              FROM (SELECT *
                      FROM bud_funds_limits_b
                     WHERE     dt = TO_DATE (:month_list, 'dd.mm.yyyy')
                           AND dpt_id = :dpt_id) b,
                   (SELECT DISTINCT tf.tn
                      FROM bud_tn_fil tf, bud_fil f
                     WHERE tf.bud_id = f.id AND f.dpt_id = :dpt_id
                    UNION
                    SELECT db
                      FROM bud_funds_limits_b
                     WHERE     dt = TO_DATE (:month_list, 'dd.mm.yyyy')
                           AND dpt_id = :dpt_id) l,
                   user_list u,
                   bud_funds f
             WHERE     b.db(+) = l.tn
                   AND l.tn = u.tn
                   AND NVL (u.is_kk, 0) = :kk
                   AND f.dpt_id = :dpt_id
                   AND f.planned = 1
          ORDER BY l.tn, f.id) dbf,
         (SELECT *
            FROM bud_funds_limits_f
           WHERE     dt = TO_DATE (:month_list, 'dd.mm.yyyy')
                 AND dpt_id = :dpt_id
                 AND kk = :kk) fd,
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
                                                    AND accepted = 2),
                                            0),
                                         0, (SELECT MAX (accept_order)
                                               FROM bud_ru_zay_accept
                                              WHERE z_id = z.id),
                                         (SELECT MAX (accept_order)
                                            FROM bud_ru_zay_accept
                                           WHERE     z_id = z.id
                                                 AND accepted = 2))) =
                          1
          /*AND (SELECT rep_accepted
                        FROM bud_ru_zay_accept
                       WHERE     z_id = z.id
                             AND accept_order =
                                    DECODE (
                                       NVL (
                                          (SELECT MAX (accept_order)
                                             FROM bud_ru_zay_accept
                                            WHERE z_id = z.id AND rep_accepted = 2),
                                          0),
                                       0, (SELECT MAX (accept_order)
                                             FROM bud_ru_zay_accept
                                            WHERE     z_id = z.id
                                                  AND rep_accepted IS NOT NULL),
                                       (SELECT MAX (accept_order)
                                          FROM bud_ru_zay_accept
                                         WHERE z_id = z.id AND rep_accepted = 2))) =
                        1*/
          /*раскомменитровать,
          если все-таки нужно будет брать
          согласованные отчеты, а не заявки*/
          GROUP BY z.tn, z.funds) fakt,
         (SELECT *
            FROM bud_funds_limits_ft ft, bud_funds_limits_h h
           WHERE     ft.dt = TO_DATE (:month_list, 'dd.mm.yyyy')
                 AND ft.dpt_id = :dpt_id
                 AND ft.kk = :kk
                 AND ft.dt = h.dt
                 AND ft.dpt_id = h.dpt_id
                 AND ft.kk = h.kk
                 AND h.ok_dpu = 1) accepted
   WHERE     fd.fund(+) = dbf.id
         AND fakt.funds(+) = dbf.id
         AND dbf.tn = fd.db(+)
         AND dbf.tn = fakt.tn(+)
         AND accepted.fund(+) = dbf.id
GROUP BY dbf.id,
         dbf.name,
         accepted.plan_val,
         accepted.planl_val
ORDER BY dbf.name