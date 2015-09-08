/* Formatted on 17/02/2015 20:18:24 (QP5 v5.227.12220.39724) */
  SELECT f.id, f.name, taf.ok_db_tn
    FROM bud_fil f,
         bud_tn_fil tf,
         (SELECT fil, ok_db_tn
            FROM bud_svod_taf
           WHERE dt = TO_DATE (:dt, 'dd.mm.yyyy')) taf
   WHERE     f.id = taf.fil(+)
         AND taf.ok_db_tn IS NULL
         AND f.id = tf.bud_id
         AND tf.tn = (SELECT parent
                        FROM parents
                       WHERE tn = :tn)
         AND f.dpt_id = :dpt_id
         AND (   f.data_end IS NULL
              OR TRUNC (f.data_end, 'mm') >= TO_DATE (:dt, 'dd.mm.yyyy'))
ORDER BY f.name