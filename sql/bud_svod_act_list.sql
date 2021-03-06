/* Formatted on 05.12.2017 22:25:45 (QP5 v5.252.13127.32867) */
SELECT z.act,
       z.act_name,
       TO_CHAR (z.act_month, 'dd.mm.yyyy') act_month,
       TO_NUMBER (TO_CHAR (z.act_month, 'mm')) month,
       TO_NUMBER (TO_CHAR (z.act_month, 'yyyy')) y,
       z1.sales,
       z1.bonus,
       z1.zat,
       z1.c,
       z1.tp
  FROM bud_act_fund z,
       (  SELECT s.act,
                 s.m,
                 SUM (s.sales) sales,
                 SUM (s.bonus) bonus,
                 DECODE (SUM (s.sales),
                         0, 0,
                         SUM (s.bonus) / SUM (s.sales) * 100)
                    zat,
                 COUNT (*) c,
                 SUM (s.tp) tp
            FROM act_svod s, bud_svod_zp zp
           WHERE     s.db_tn = DECODE ( :db, 0, s.db_tn, :db)
                 AND zp.h_eta = s.h_fio_eta
                 AND zp.dt = TO_DATE ( :dt, 'dd.mm.yyyy')
                 AND zp.dpt_id = :dpt_id
                 AND s.dpt_id = :dpt_id
                 AND zp.fil IS NOT NULL
                 AND DECODE ( :fil, 0, zp.fil, :fil) = zp.fil
                 AND (   zp.fil IN (SELECT fil_id
                                      FROM clusters_fils
                                     WHERE :clusters = CLUSTER_ID)
                      OR :clusters = 0)
        GROUP BY s.act, s.m) z1
 WHERE     z.act = z1.act
       AND TO_NUMBER (TO_CHAR (z.act_month, 'mm')) = z1.m
       AND z.act_month = TO_DATE ( :dt, 'dd.mm.yyyy')
UNION
SELECT z.act,
       z.act_name,
       TO_CHAR (z.act_month, 'dd.mm.yyyy') act_month,
       TO_NUMBER (TO_CHAR (z.act_month, 'mm')) month,
       TO_NUMBER (TO_CHAR (z.act_month, 'yyyy')) y,
       z1.sales,
       z1.bonus,
       z1.zat,
       z1.c,
       null
  FROM bud_act_fund z,
       (  SELECT s.act,
                 s.m,
                 SUM (s.sales) sales,
                 SUM (s.bonus) bonus,
                 DECODE (SUM (s.sales),
                         0, 0,
                         SUM (s.bonus) / SUM (s.sales) * 100)
                    zat,
                 COUNT (*) c
            FROM act_svodn s
           WHERE     s.db_tn = DECODE ( :db, 0, s.db_tn, :db)
                 AND DECODE ( :fil, 0, s.fil_kod, :fil) = s.fil_kod
                 AND (   s.fil_kod IN (SELECT fil_id
                                         FROM clusters_fils
                                        WHERE :clusters = CLUSTER_ID)
                      OR :clusters = 0)
        GROUP BY s.act, s.m) z1
 WHERE     z.act = z1.act
       AND TO_NUMBER (TO_CHAR (z.act_month, 'mm')) = z1.m
       AND z.act_month = TO_DATE ( :dt, 'dd.mm.yyyy')
ORDER BY act_name