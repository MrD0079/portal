/* Formatted on 26/08/2014 12:50:13 (QP5 v5.227.12220.39724) */
  SELECT wm_concat (c.name)
    FROM clusters c, clusters_fils cf
   WHERE c.id = cf.CLUSTER_ID AND cf.fil_id = :id
ORDER BY c.name