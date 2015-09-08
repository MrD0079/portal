/* Formatted on 17.09.2014 13:01:12 (QP5 v5.227.12220.39724) */
  SELECT z.id,
         z.name,
         DECODE (cf.fil, NULL, NULL, 1) activ,
         nd.name nd_name
    FROM bud_fil z, distr_prot_conq_fil cf, bud_nd nd
   WHERE     z.dpt_id = :dpt_id
         AND z.id = cf.fil(+)
         AND :conq_id = cf.conq(+)
         AND (z.data_end IS NULL OR z.data_end > LAST_DAY (TRUNC (SYSDATE)))
         AND z.nd = nd.id(+)
ORDER BY z.name