/* Formatted on 12.04.2017 16:44:12 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT tf.bud_id, f.name bud_name
    FROM bud_svod_taf t,
         bud_tn_fil tf,
         user_list u,
         bud_fil f
   WHERE     u.tn = tf.tn
         AND f.id = tf.bud_id
         AND u.tn IN (SELECT slave
                        FROM full
                       WHERE master = :tn)
         AND TRUNC (TO_DATE ( :dt, 'dd.mm.yyyy'), 'mm') = t.dt(+)
         AND t.fil(+) = tf.bud_id
         AND t.ok_db_tn IS NULL
         AND (   f.data_end IS NULL
              OR f.data_end >= TRUNC (TO_DATE ( :dt, 'dd.mm.yyyy'), 'mm'))
ORDER BY f.name