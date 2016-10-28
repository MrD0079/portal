/* Formatted on 27/10/2015 15:04:18 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT f.id, f.name
    FROM bud_fil f, bud_tn_fil tf
   WHERE     f.id = tf.bud_id
         AND (   (    tf.tn = (SELECT parent
                                 FROM parents
                                WHERE tn = :tn)
                  AND (SELECT has_parent_db
                         FROM user_list
                        WHERE tn = :tn) = 1)
              OR (tf.tn IN (SELECT slave
                              FROM full
                             WHERE master = :tn))
              OR (    tf.tn = :tn
                  AND (SELECT is_db
                         FROM user_list
                        WHERE tn = :tn) = 1))
         AND f.dpt_id = :dpt_id
         AND f.data_end IS NULL
ORDER BY f.name