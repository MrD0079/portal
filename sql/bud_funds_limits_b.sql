/* Formatted on 15.01.2015 17:59:44 (QP5 v5.227.12220.39724) */
  SELECT NVL (b.db, l.tn) db,
         NVL (b.db_fio, u.fio) db_fio,
         NVL (b.fil_list, fl.fil_list) fil_list,
         TO_CHAR (b.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
         b.plan
    FROM (SELECT *
            FROM bud_funds_limits_b
           WHERE dt = TO_DATE (:month_list, 'dd.mm.yyyy') AND dpt_id = :dpt_id) b,
         (SELECT DISTINCT tf.tn
            FROM bud_tn_fil tf, bud_fil f
           WHERE tf.bud_id = f.id AND f.dpt_id = :dpt_id
          UNION
          SELECT db
            FROM bud_funds_limits_b
           WHERE dt = TO_DATE (:month_list, 'dd.mm.yyyy') AND dpt_id = :dpt_id) l,
         user_list u,
         (  SELECT tf.tn, SUBSTR (wm_concat ('<br>' || f.name), 5, 4000) fil_list
              FROM bud_tn_fil tf,
                   (  SELECT *
                        FROM bud_fil
                       WHERE    data_end IS NULL
                             OR TRUNC (data_end, 'mm') >=
                                   TO_DATE (:month_list, 'dd.mm.yyyy')
                    ORDER BY name) f
             WHERE tf.bud_id = f.id
          GROUP BY tf.tn) fl
   WHERE     b.db(+) = l.tn
         AND l.tn = u.tn
         AND fl.tn(+) = l.tn
         AND NVL (u.is_kk, 0) = :kk
ORDER BY db_fio