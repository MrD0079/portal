/* Formatted on 11/05/2016 09:07:20 (QP5 v5.252.13127.32867) */
  SELECT m.id,
         m.name,
         h.plan_weight,
         h.plan_sum,
         h.plan_sume,
         h.fakt_weight,
         h.fakt_sum,
         h.fakt_sume
    FROM (  SELECT h.market,
                   SUM (h.plan_weight) plan_weight,
                   SUM (h.plan_sum) plan_sum,
                   SUM (h.plan_sume) plan_sume,
                   SUM (ms.fakt_weight) / 1000 fakt_weight,
                   SUM (ms.fakt_sum) fakt_sum,
                   SUM (ms.fakt_sume) fakt_sume
              FROM dpnr_budjet_head h,
                   (SELECT DISTINCT m_id
                      FROM dpnr_market_tn
                     WHERE tn = DECODE ( :dpnr, 0, tn, :dpnr)) mt,
                   (SELECT m.id,
                           s.dt,
                           s.qty fakt_weight,
                           s.summ_dol fakt_sum,
                           s.summ_evr fakt_sume
                      FROM dpnr_markets m, sales_export s
                     WHERE     m.kod = s.country_id
                           AND s.dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                        AND TO_DATE ( :ed, 'dd.mm.yyyy')) ms
             WHERE     h.dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                AND TO_DATE ( :ed, 'dd.mm.yyyy')
                   AND h.market IN ( :m_id)
                   AND h.market = mt.m_id(+)
                   AND (   :ok_chief = 1
                        OR :ok_chief = 2 AND h.ok_chief = 1
                        OR :ok_chief = 3 AND NVL (h.ok_chief, 0) <> 1)
                   AND h.market = ms.id(+)
                   AND h.dt = ms.dt(+)
          GROUP BY h.market) h,
         dpnr_markets m
--   WHERE m.id = h.market(+)
   WHERE m.id = h.market
ORDER BY m.name