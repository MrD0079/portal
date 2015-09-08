/* Formatted on 17/06/2015 15:42:46 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT f.id, f.name
    FROM bud_fil f, bud_tn_fil tf
   WHERE     f.id = tf.bud_id
         AND tf.tn IN (SELECT slave
                         FROM full
                        WHERE master = :tn)
         /*AND f.dpt_id = :dpt_id*/
         AND (   f.data_end IS NULL
              OR TRUNC (f.data_end, 'mm') >=
                    (SELECT data
                       FROM calendar
                      WHERE y = :y AND my = :m AND data = TRUNC (data, 'mm')))
ORDER BY f.name