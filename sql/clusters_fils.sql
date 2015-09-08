/* Formatted on 26/08/2014 12:58:13 (QP5 v5.227.12220.39724) */
  SELECT f.name,
         f.id,
         DECODE (cf.fil_id, NULL, NULL, 1) selected,
         FN_QUERY2STR (
               'SELECT c.name '
            || 'FROM clusters c, clusters_fils cf '
            || 'WHERE c.id = cf.CLUSTER_ID AND cf.fil_id = '
            || f.id
            || ' order by c.name',
            ',')
            clusters_list
    FROM clusters c, clusters_fils cf, bud_fil f
   WHERE     cf.CLUSTER_ID(+) = :id
         AND cf.fil_id(+) = f.id
         AND f.dpt_id = c.dpt_id
         AND c.id = :id
ORDER BY f.name