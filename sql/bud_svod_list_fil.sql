/* Formatted on 02/02/2015 16:59:06 (QP5 v5.227.12220.39724) */
  SELECT f.id, f.name, tf.db_list
    FROM (  SELECT tf.bud_id,
                   SUBSTR (wm_concat ('<br>' || u.fio), 5, 4000) db_list
              FROM bud_tn_fil tf, user_list u
             WHERE     u.tn = tf.tn
                   AND (   u.tn IN (SELECT slave
                                      FROM full
                                     WHERE master = :tn)
                        OR (SELECT NVL (is_traid, 0)
                              FROM user_list
                             WHERE tn = :tn) = 1
                        OR (SELECT NVL (is_traid_kk, 0)
                              FROM user_list
                             WHERE tn = :tn) = 1)
          GROUP BY tf.bud_id) tf,
         bud_fil f
   WHERE     f.id = tf.bud_id
         AND f.dpt_id = :dpt_id
         AND (   f.data_end IS NULL
              OR TRUNC (f.data_end, 'mm') >= TO_DATE (:dt, 'dd.mm.yyyy'))
ORDER BY f.name