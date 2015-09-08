/* Formatted on 03/02/2015 11:09:09 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT c.id, c.name
    FROM clusters c, clusters_fils cf, bud_tn_fil bf
   WHERE     c.id = cf.CLUSTER_ID
         AND c.dpt_id = :dpt_id
         AND cf.fil_id = bf.bud_id
         AND (   bf.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_traid, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_traid_kk, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR bf.bud_id IN
                    (SELECT fil_id
                       FROM clusters_fils
                      WHERE CLUSTER_ID IN
                               (SELECT CLUSTER_ID
                                  FROM clusters_fils
                                 WHERE fil_id IN (SELECT id
                                                    FROM bud_fil
                                                   WHERE login = :login))))
ORDER BY c.name