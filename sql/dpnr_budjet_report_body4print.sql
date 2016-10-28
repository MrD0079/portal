/* Formatted on 11/05/2016 09:21:13 (QP5 v5.252.13127.32867) */
  SELECT --cid,
         cname,
         --spid,
         spname,
         --scid,
         scname,
         --t.mid,
         t.mname,
         SUM (b.plan) plan,
         SUM (b.fakt) fakt,
         /*REPLACE (*/
         TRIM (
            ';' FROM wm_concat (
                        CASE
                           WHEN LENGTH (comm) > 0 THEN ';' || comm
                           ELSE NULL
                        END))         /*,
                  ';',
                  '<br>')*/
            comm,
         DECODE (
            (SELECT SUM (plan_sum)
               FROM dpnr_budjet_head h,
                    (SELECT DISTINCT m_id
                       FROM dpnr_market_tn
                      WHERE tn = DECODE ( :dpnr, 0, tn, :dpnr)) mt
              WHERE     dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                               AND TO_DATE ( :ed, 'dd.mm.yyyy')
                    AND market IN ( :m_id)
                    AND market = mt.m_id
                    AND (   :ok_chief = 1
                         OR :ok_chief = 2 AND h.ok_chief = 1
                         OR :ok_chief = 3 AND NVL (h.ok_chief, 0) <> 1)),
            0, 0,
              SUM (b.plan)
            / (SELECT SUM (plan_sum)
                 FROM dpnr_budjet_head h,
                      (SELECT DISTINCT m_id
                         FROM dpnr_market_tn
                        WHERE tn = DECODE ( :dpnr, 0, tn, :dpnr)) mt
                WHERE     dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                 AND TO_DATE ( :ed, 'dd.mm.yyyy')
                      AND market IN ( :m_id)
                      AND market = mt.m_id
                      AND (   :ok_chief = 1
                           OR :ok_chief = 2 AND h.ok_chief = 1
                           OR :ok_chief = 3 AND NVL (h.ok_chief, 0) <> 1))
            * 100)
            zat_plan,
         DECODE (
            (SELECT SUM (plan_sume)
               FROM dpnr_budjet_head h,
                    (SELECT DISTINCT m_id
                       FROM dpnr_market_tn
                      WHERE tn = DECODE ( :dpnr, 0, tn, :dpnr)) mt
              WHERE     dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                               AND TO_DATE ( :ed, 'dd.mm.yyyy')
                    AND market IN ( :m_id)
                    AND market = mt.m_id
                    AND (   :ok_chief = 1
                         OR :ok_chief = 2 AND h.ok_chief = 1
                         OR :ok_chief = 3 AND NVL (h.ok_chief, 0) <> 1)),
            0, 0,
              SUM (b.plan)
            / (SELECT SUM (plan_sume)
                 FROM dpnr_budjet_head h,
                      (SELECT DISTINCT m_id
                         FROM dpnr_market_tn
                        WHERE tn = DECODE ( :dpnr, 0, tn, :dpnr)) mt
                WHERE     dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                 AND TO_DATE ( :ed, 'dd.mm.yyyy')
                      AND market IN ( :m_id)
                      AND market = mt.m_id
                      AND (   :ok_chief = 1
                           OR :ok_chief = 2 AND h.ok_chief = 1
                           OR :ok_chief = 3 AND NVL (h.ok_chief, 0) <> 1))
            * 100)
            zat_plane,
         DECODE (
            (SELECT SUM (ms.fakt_sum)
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
                    AND market IN ( :m_id)
                    AND market = mt.m_id
                    AND (   :ok_chief = 1
                         OR :ok_chief = 2 AND h.ok_chief = 1
                         OR :ok_chief = 3 AND NVL (h.ok_chief, 0) <> 1)
                    AND h.market = ms.id(+)
                    AND h.dt = ms.dt(+)),
            0, 0,
              SUM (b.fakt)
            / (SELECT SUM (ms.fakt_sum)
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
                      AND market IN ( :m_id)
                      AND market = mt.m_id
                      AND (   :ok_chief = 1
                           OR :ok_chief = 2 AND h.ok_chief = 1
                           OR :ok_chief = 3 AND NVL (h.ok_chief, 0) <> 1)
                      AND h.market = ms.id(+)
                      AND h.dt = ms.dt(+))
            * 100)
            zat_fakt,
         DECODE (
            (SELECT SUM (ms.fakt_sume)
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
                    AND market IN ( :m_id)
                    AND market = mt.m_id
                    AND (   :ok_chief = 1
                         OR :ok_chief = 2 AND h.ok_chief = 1
                         OR :ok_chief = 3 AND NVL (h.ok_chief, 0) <> 1)
                    AND h.market = ms.id(+)
                    AND h.dt = ms.dt(+)),
            0, 0,
              SUM (b.fakt)
            / (SELECT SUM (ms.fakt_sume)
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
                      AND market IN (:m_id)
                      AND market = mt.m_id
                      AND (   :ok_chief = 1
                           OR :ok_chief = 2 AND h.ok_chief = 1
                           OR :ok_chief = 3 AND NVL (h.ok_chief, 0) <> 1)
                      AND h.market = ms.id(+)
                      AND h.dt = ms.dt(+))
            * 100)
            zat_fakte
    FROM (SELECT c.id cid,
                 c.name cname,
                 sp.id spid,
                 sp.cost_item spname,
                 sc.id scid,
                 sc.cost_item scname,
                 m.id mid,
                 m.name mname
            FROM dpnr_compensations c,
                 dpnr_statya sp,
                 dpnr_statya sc,
                 dpnr_markets m
           WHERE sp.id = sc.parent) t,
         (SELECT b.*
            FROM dpnr_budjet_body b,
                 dpnr_budjet_head h,
                 (SELECT DISTINCT m_id
                    FROM dpnr_market_tn
                   WHERE tn = DECODE ( :dpnr, 0, tn, :dpnr)) mt
           WHERE     b.dt BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                              AND TO_DATE ( :ed, 'dd.mm.yyyy')
                 AND b.market IN ( :m_id)
                 AND b.market = mt.m_id
                 AND b.market = h.market(+)
                 AND b.dt = h.dt(+)
                 AND (   :ok_chief = 1
                      OR :ok_chief = 2 AND h.ok_chief = 1
                      OR :ok_chief = 3 AND NVL (h.ok_chief, 0) <> 1)) b
   WHERE t.cid = b.cmp(+) AND t.scid = b.st(+) AND t.mid = b.market(+)
--   WHERE t.cid = b.cmp AND t.scid = b.st AND t.mid = b.market
GROUP BY CUBE (--cid,
               cname,
               --spid,
               spname,
               --scid,
               scname,
               --t.mid,
               t.mname)
ORDER BY --cid,
         cname,
         --spid,
         spname,
         --scid,
         scname,
         --t.mid,
         t.mname