/* Formatted on 25/02/2015 19:08:44 (QP5 v5.227.12220.39724) */
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
                   decode(SUM (s.sales),0,0,SUM (s.bonus) / SUM (s.sales) * 100) zat,
                   COUNT (*) c,
                   SUM (s.tp) tp
              FROM act_svod s, bud_svod_zp zp
             WHERE     s.db_tn = DECODE (:db, 0, s.db_tn, :db)
                   AND zp.h_eta = s.h_fio_eta
                   AND zp.dt = TO_DATE (:dt, 'dd.mm.yyyy')
                   AND zp.dpt_id = :dpt_id
                   AND s.dpt_id = :dpt_id
                   AND zp.fil IS NOT NULL
                   AND DECODE (:fil, 0, zp.fil, :fil) = zp.fil
                   AND (   zp.fil IN (SELECT fil_id
                                        FROM clusters_fils
                                       WHERE :clusters = CLUSTER_ID)
                        OR :clusters = 0)
          GROUP BY s.act, s.m) z1
   WHERE     z.act = z1.act
         AND TO_NUMBER (TO_CHAR (z.act_month, 'mm')) = z1.m
         AND z.act_month = TO_DATE (:dt, 'dd.mm.yyyy')
ORDER BY z.act_name