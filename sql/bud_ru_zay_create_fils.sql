/* Formatted on 26/06/2015 11:04:38 (QP5 v5.227.12220.39724) */
  SELECT tf.bud_id, f.name bud_name
    FROM bud_svod_taf t,
         bud_tn_fil tf,
         user_list u,
         bud_fil f
   WHERE     u.tn = tf.tn
         AND f.id = tf.bud_id
         AND u.tn IN (SELECT slave
                        FROM full
                       WHERE master = :tn)
         AND TRUNC (TO_DATE (:dt, 'dd.mm.yyyy'), 'mm') = t.dt(+)
         AND t.fil(+) = tf.bud_id
         AND t.ok_db_tn IS NULL
ORDER BY f.name