/* Formatted on 10/02/2015 17:17:48 (QP5 v5.227.12220.39724) */
  SELECT bud.id,
         bud.name,
         b.discount,
         b.discount_kk,
         TO_CHAR (b.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
         b.fio,
         b.comm
    FROM bud_fil bud,
         clusters_fils cf,
         (SELECT DISTINCT bud_id
            FROM bud_tn_fil
           WHERE     tn = DECODE (:db, 0, tn, :db)
                 AND bud_id = DECODE (:distr, 0, bud_id, :distr)
                 AND (   tn IN (SELECT slave
                                  FROM full
                                 WHERE master = :tn)
                      OR (SELECT NVL (is_traid, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1
                      OR (SELECT NVL (is_traid_kk, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1
                      OR (SELECT NVL (is_do, 0)
                            FROM user_list
                           WHERE tn = :tn) = 1)) tf,
         (SELECT *
            FROM bud_fil_discount_body
           WHERE dt = TO_DATE (:sd, 'dd.mm.yyyy')) b
   WHERE     bud.dpt_id = :dpt_id
         AND bud.id = tf.bud_id
         AND (   (:fil_activ = 2)
              OR (    :fil_activ = 0
                  AND NVL (bud.data_end, TRUNC (SYSDATE)) <
                         TRUNC (SYSDATE, 'mm'))
              OR (    :fil_activ = 1
                  AND NVL (bud.data_end, TRUNC (SYSDATE)) >=
                         TRUNC (SYSDATE, 'mm')))
         AND bud.id = b.distr(+)
         AND bud.id = cf.fil_id(+)
         AND NVL (cf.CLUSTER_ID, 0) =
                DECODE (:clusters, 0, NVL (cf.CLUSTER_ID, 0), :clusters)
ORDER BY bud.name